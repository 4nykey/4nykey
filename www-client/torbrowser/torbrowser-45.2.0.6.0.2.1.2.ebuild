# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
WANT_AUTOCONF="2.1"
MOZCONFIG_OPTIONAL_WIFI=1
MOZCONFIG_OPTIONAL_JIT="enabled"

inherit check-reqs flag-o-matic toolchain-funcs eutils gnome2-utils mozconfig-v6.${PV%%.*} multilib pax-utils autotools fdo-mime

MY_PN="firefox"
MOZ_PV="$(get_version_component_range -3)esr"
PATCH="${MY_PN}-${PV%%.*}.0-patches-04"

# see https://gitweb.torproject.org/builders/tor-browser-bundle.git/tree/gitian/versions?h=maint-4.0
# https://dist.torproject.org/torbrowser
TOR_PV="$(version_format_string '$4.$5.$6')"
if [[ -z ${PV%%*_alpha} ]]; then
	TOR_PV="$(version_format_string '$4.$5a$6')"
else
	KEYWORDS="~amd64 ~x86"
fi
TOR_PV="${TOR_PV%.0}"
# https://gitweb.torproject.org/tor-browser.git/refs/tags
GIT_TAG="$(version_format_string 'tor-browser-${MOZ_PV}-$4.$5-$7-build$8')"

DESCRIPTION="The Tor Browser"
HOMEPAGE="
https://www.torproject.org/projects/torbrowser.html
https://gitweb.torproject.org/tor-browser.git
"

SLOT="0"
# BSD license applies to torproject-related code like the patches
# icons are under CCPL-Attribution-3.0
LICENSE="BSD CC-BY-3.0 MPL-2.0 GPL-2 LGPL-2.1"
IUSE="hardened +hwaccel selinux test"

BASE_SRC_URI="https://dist.torproject.org/${PN}/${TOR_PV}"
SRC_URI="
	https://gitweb.torproject.org/tor-browser.git/snapshot/${GIT_TAG}.tar.gz
	-> ${GIT_TAG}.tar.gz
	https://dev.gentoo.org/~anarchy/mozilla/patchsets/${PATCH}.tar.xz
	https://dev.gentoo.org/~axs/mozilla/patchsets/${PATCH}.tar.xz
	https://dev.gentoo.org/~polynomial-c/mozilla/patchsets/${PATCH}.tar.xz
	x86? (
		${BASE_SRC_URI}/tor-browser-linux32-${TOR_PV}_en-US.tar.xz
	)
	amd64? (
		${BASE_SRC_URI}/tor-browser-linux64-${TOR_PV}_en-US.tar.xz
	)
"
RESTRICT="primaryuri"

DEPEND="
	${RDEPEND}
	>=dev-lang/yasm-1.1
	virtual/opengl
"

QA_PRESTRIPPED="usr/lib*/${PN}/${MY_PN}/firefox"

S="${WORKDIR}/${GIT_TAG}"
BUILD_OBJ_DIR="${WORKDIR}/tb"

pkg_setup() {
	moz_pkgsetup

	# Avoid PGO profiling problems due to enviroment leakage
	# These should *always* be cleaned up anyway
	unset DBUS_SESSION_BUS_ADDRESS \
		DISPLAY \
		ORBIT_SOCKETDIR \
		SESSION_MANAGER \
		XDG_SESSION_COOKIE \
		XAUTHORITY

}

pkg_pretend() {
	# Ensure we have enough disk space to compile
	if use debug || use test ; then
		CHECKREQS_DISK_BUILD="8G"
	else
		CHECKREQS_DISK_BUILD="4G"
	fi
	check-reqs_pkg_setup
}

src_prepare() {
	# Apply gentoo firefox patches
	eapply "${WORKDIR}/firefox" \
		"${FILESDIR}"/${P%%.*}-exedir.patch

	# Revert "Change the default Firefox profile directory to be TBB-relative"
	# https://gitweb.torproject.org/tor-browser.git/commit/?id=72dfe790235d714da084b45d341d3cb46a88cd60
	eapply -R "${FILESDIR}"/${P%%.*}-profiledir.patch

	# Allow user to apply any additional patches without modifing ebuild
	eapply_user

	# Enable gnomebreakpad
	if use debug ; then
		sed -i -e "s:GNOME_DISABLE_CRASH_DIALOG=1:GNOME_DISABLE_CRASH_DIALOG=0:g" \
			"${S}"/build/unix/run-mozilla.sh || die "sed failed!"
	fi

	# Ensure that our plugins dir is enabled as default
	sed -i -e "s:/usr/lib/mozilla/plugins:/usr/lib/nsbrowser/plugins:" \
		"${S}"/xpcom/io/nsAppFileLocationProvider.cpp || die "sed failed to replace plugin path for 32bit!"
	sed -i -e "s:/usr/lib64/mozilla/plugins:/usr/lib64/nsbrowser/plugins:" \
		"${S}"/xpcom/io/nsAppFileLocationProvider.cpp || die "sed failed to replace plugin path for 64bit!"

	# Fix sandbox violations during make clean, bug 372817
	sed -e "s:\(/no-such-file\):${T}\1:g" \
		-i "${S}"/config/rules.mk \
		-i "${S}"/nsprpub/configure{.in,} \
		|| die

	# Don't exit with error when some libs are missing which we have in
	# system.
	sed '/^MOZ_PKG_FATAL_WARNINGS/s@= 1@= 0@' \
		-i "${S}"/browser/installer/Makefile.in || die

	# Don't error out when there's no files to be removed:
	sed 's@\(xargs rm\)$@\1 -f@' \
		-i "${S}"/toolkit/mozapps/installer/packager.mk || die

	# Keep codebase the same even if not using official branding
	sed '/^MOZ_DEV_EDITION=1/d' \
		-i "${S}"/browser/branding/aurora/configure.sh || die

	eautoreconf

	# Must run autoconf in js/src
	cd "${S}"/js/src || die
	eautoconf

	# Need to update jemalloc's configure
	cd "${S}"/memory/jemalloc/src || die
	WANT_AUTOCONF= eautoconf
}

src_configure() {
	MOZILLA_FIVE_HOME="/usr/$(get_libdir)/${PN}/${PN}"
	MEXTENSIONS="default"
	# Google API keys (see http://www.chromium.org/developers/how-tos/api-keys)
	# Note: These are for Gentoo Linux use ONLY. For your own distribution, please
	# get your own set of keys.
	_google_api_key=AIzaSyDEAOvatFo0eTgsV_ZlEzx0ObmepsMzfAc

	####################################
	#
	# mozconfig, CFLAGS and CXXFLAGS setup
	#
	####################################

	mozconfig_init
	mozconfig_config

	# We want rpath support to prevent unneeded hacks on different libc variants
	append-ldflags -Wl,-rpath="${MOZILLA_FIVE_HOME}"

	# Add full relro support for hardened
	use hardened && append-ldflags "-Wl,-z,relro,-z,now"

	# Only available on mozilla-overlay for experimentation -- Removed in Gentoo repo per bug 571180
	#use egl && mozconfig_annotate 'Enable EGL as GL provider' --with-gl-provider=EGL

	# Setup api key for location services
	echo -n "${_google_api_key}" > "${S}"/google-api-key
	mozconfig_annotate '' --with-google-api-keyfile="${S}/google-api-key"

	mozconfig_annotate '' --enable-extensions="${MEXTENSIONS}"
	mozconfig_annotate '' --disable-mailnews

	# Other ff-specific settings
	mozconfig_annotate '' --with-default-mozilla-five-home=${MOZILLA_FIVE_HOME}

	echo "mk_add_options MOZ_OBJDIR=${BUILD_OBJ_DIR}" >> "${S}"/.mozconfig

	# Rename the install directory and the executable
	mozconfig_annotate 'torbrowser' --libdir="${EPREFIX}"/usr/$(get_libdir)/${PN}
	mozconfig_annotate 'torbrowser' --with-app-name=torbrowser
	mozconfig_annotate 'torbrowser' --with-app-basename=torbrowser
	mozconfig_annotate 'torbrowser' --disable-tor-browser-update
	mozconfig_annotate 'torbrowser' --with-tor-browser-version=${TOR_PV}

	mozconfig_annotate 'torbrowser' --without-system-nspr
	mozconfig_annotate 'torbrowser' --without-system-nss
	mozconfig_annotate 'torbrowser' --enable-bundled-fonts
	mozconfig_annotate 'torbrowser' --enable-tree-freetype

	# Finalize and report settings
	mozconfig_final

	if [[ $(gcc-major-version) -lt 4 ]]; then
		append-cxxflags -fno-stack-protector
	fi

	# workaround for funky/broken upstream configure...
	emake -f client.mk configure
}

src_compile() {
	CC="$(tc-getCC)" CXX="$(tc-getCXX)" LD="$(tc-getLD)" \
	MOZ_MAKE_FLAGS="${MAKEOPTS}" SHELL="${SHELL:-${EPREFIX%/}/bin/bash}" \
	emake -f client.mk realbuild
}

src_install() {
	MOZILLA_FIVE_HOME="/usr/$(get_libdir)/${PN}/${PN}"

	cd "${BUILD_OBJ_DIR}" || die

	# Pax mark xpcshell for hardened support, only used for startupcache creation.
	pax-mark m "${BUILD_OBJ_DIR}"/dist/bin/xpcshell

	# Add an emty default prefs for mozconfig-3.eclass
	touch "${BUILD_OBJ_DIR}/dist/bin/browser/defaults/preferences/all-gentoo.js" \
		|| die

	if use hwaccel ; then
		cat "${FILESDIR}"/gentoo-hwaccel-prefs.js-1 >> \
		"${BUILD_OBJ_DIR}/dist/bin/browser/defaults/preferences/all-gentoo.js" \
		|| die
	fi

	echo "pref(\"extensions.autoDisableScopes\", 3);" >> \
		"${BUILD_OBJ_DIR}/dist/bin/browser/defaults/preferences/all-gentoo.js" \
		|| die

	echo "pref(\"general.useragent.locale\", \"en-US\");" \
		>> "${BUILD_OBJ_DIR}/dist/bin/browser/defaults/preferences/000-tor-browser.js" \
		|| die

	MOZ_MAKE_FLAGS="${MAKEOPTS}" \
	emake DESTDIR="${D}" install

	# Install icons and .desktop for menu entry
	local size sizes icon_path
	sizes="16 22 24 32 48 256"
	icon_path="${S}/browser/branding/official"
	for size in ${sizes}; do
		newicon -s ${size} "${icon_path}/default${size}.png" ${PN}.png
	done
	# The 128x128 icon has a different name
	newicon -s 128 "${icon_path}/mozicon128.png" ${PN}.png
	make_desktop_entry ${PN} "Tor Browser" ${PN} "Network;WebBrowser" "StartupWMClass=Torbrowser"

	# Add StartupNotify=true bug 237317
	if use startup-notification ; then
		echo "StartupNotify=true" \
			>> "${ED}/usr/share/applications/${PN}-${PN}.desktop" \
			|| die
	fi

	# Required in order to use plugins and even run torbrowser on hardened.
	pax-mark m "${ED}"${MOZILLA_FIVE_HOME}/plugin-container
	# Required in order for jit to work on hardened, as of torbroser-31
	use jit && pax-mark pm "${ED}"${MOZILLA_FIVE_HOME}/{torbrowser,torbrowser-bin}

	# revdep-rebuild entry
	insinto /etc/revdep-rebuild
	echo "SEARCH_DIRS_MASK=${MOZILLA_FIVE_HOME}" >> ${T}/10${PN}
	doins "${T}"/10${PN} || die

	# Profile without the tor-launcher extension
	# see: https://trac.torproject.org/projects/tor/ticket/10160
	local profile_dir="${WORKDIR}/tor-browser_en-US/Browser/TorBrowser/Data/Browser/profile.default"

	docompress -x "${EROOT}/usr/share/doc/${PF}/tor-launcher@torproject.org.xpi"
	dodoc "${profile_dir}/extensions/tor-launcher@torproject.org.xpi"
	rm "${profile_dir}/extensions/tor-launcher@torproject.org.xpi" || die "Failed to remove torlauncher extension"

	insinto ${MOZILLA_FIVE_HOME}/browser/defaults/profile
	doins -r "${profile_dir}"/{extensions,preferences,bookmarks.html}

	dodoc "${WORKDIR}/tor-browser_en-US/Browser/TorBrowser/Docs/ChangeLog.txt"
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	ewarn "This patched firefox build is _NOT_ recommended by Tor upstream but uses"
	ewarn "the exact same sources. Use this only if you know what you are doing!"
	elog "Torbrowser uses port 9150 to connect to Tor. You can change the port"
	elog "in the connection settings to match your setup."

	# Update mimedb for the new .desktop file
	fdo-mime_desktop_database_update
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
