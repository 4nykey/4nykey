# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
VIRTUALX_REQUIRED="pgo"
WANT_AUTOCONF="2.1"
MOZCONFIG_OPTIONAL_GTK2ONLY=1
MOZCONFIG_OPTIONAL_WIFI=1

inherit check-reqs flag-o-matic toolchain-funcs eutils gnome2-utils mozconfig-v6.${PV%%.*} pax-utils xdg-utils autotools
inherit eapi7-ver cargo
CRATES="
abort_on_panic-1.0.0
afl-0.3.2
aho-corasick-0.6.4
ansi_term-0.11.0
atty-0.2.8
bitflags-1.0.1
bitreader-0.3.1
byteorder-1.2.1
cbindgen-0.5.2
cc-1.0.9
cfg-if-0.1.2
clap-2.31.2
dtoa-0.4.2
env_logger-0.5.6
fuchsia-zircon-0.3.3
fuchsia-zircon-sys-0.3.3
humantime-1.1.1
itoa-0.4.1
lazy_static-1.0.0
libc-0.2.40
log-0.3.9
log-0.4.1
memchr-2.0.1
mp4parse-0.10.1
mp4parse_capi-0.10.1
num-traits-0.2.2
proc-macro2-0.2.3
quick-error-1.2.1
quote-0.3.15
rand-0.4.2
redox_syscall-0.1.37
redox_termios-0.1.1
regex-0.2.10
regex-syntax-0.5.3
remove_dir_all-0.5.0
rustc_version-0.2.2
semver-0.9.0
semver-parser-0.7.0
serde-1.0.36
serde_derive-1.0.21
serde_derive_internals-0.17.0
serde_json-1.0.13
standalone-quote-0.5.0
standalone-syn-0.13.0
strsim-0.7.0
syn-0.11.11
synom-0.11.3
tempdir-0.3.7
termcolor-0.3.6
termion-1.5.1
textwrap-0.9.0
thread_local-0.3.5
toml-0.4.5
ucd-util-0.1.1
unicode-width-0.1.4
unicode-xid-0.0.4
unicode-xid-0.1.0
unreachable-1.0.0
utf8-ranges-1.0.0
vec_map-0.8.0
void-1.0.2
winapi-0.3.4
winapi-i686-pc-windows-gnu-0.4.0
winapi-x86_64-pc-windows-gnu-0.4.0
wincolor-0.1.6
xdg-2.1.0
"
MY_PN="firefox"
MOZ_PV="$(ver_cut 1-3)esr"
PATCH="${MY_PN}-${PV%%.*}.5-patches-02"

# https://dist.torproject.org/torbrowser
TOR_PV="$(ver_cut 4-6)"
if [[ -z ${PV%%*_alpha} ]]; then
	TOR_PV="$(ver_rs 2 a ${TOR_PV})"
else
	KEYWORDS="~amd64 ~x86"
fi
TOR_PV="${TOR_PV%.0}"
# https://gitweb.torproject.org/tor-browser.git/refs/tags
GIT_TAG="$(ver_cut 4-5)-$(ver_cut 7-8)"
GIT_TAG="tor-browser-${MOZ_PV}-$(ver_rs 3 '-build' ${GIT_TAG})"

DESCRIPTION="The Tor Browser"
HOMEPAGE="
https://www.torproject.org/projects/torbrowser.html
https://gitweb.torproject.org/tor-browser.git
"

SLOT="0"
# BSD license applies to torproject-related code like the patches
# icons are under CCPL-Attribution-3.0
LICENSE="BSD CC-BY-3.0 MPL-2.0 GPL-2 LGPL-2.1"
IUSE="eme-free hardened hwaccel jack pgo rust selinux test"

SRC_URI="https://dist.torproject.org/${PN}/${TOR_PV}"
PATCH_URIS=( https://dev.gentoo.org/~{anarchy,axs,polynomial-c}/mozilla/patchsets/${PATCH}.tar.xz )
SRC_URI="
	https://gitweb.torproject.org/tor-browser.git/snapshot/${GIT_TAG}.tar.gz
	-> ${GIT_TAG}.tar.gz
	x86? (
		${SRC_URI}/tor-browser-linux32-${TOR_PV}_en-US.tar.xz
	)
	amd64? (
		${SRC_URI}/tor-browser-linux64-${TOR_PV}_en-US.tar.xz
	)
	${PATCH_URIS[@]}
	rust? ( $(cargo_crate_uris ${CRATES}) )
"
RESTRICT="primaryuri"

RDEPEND="
	jack? ( virtual/jack )
	>=dev-libs/nss-3.28.4
	>=dev-libs/nspr-4.13.1
	selinux? ( sec-policy/selinux-mozilla )
"
DEPEND="
	${RDEPEND}
	pgo? ( >=sys-devel/gcc-4.5 )
	rust? ( virtual/rust )
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

	if use pgo; then
		einfo
		ewarn "You will do a double build for profile guided optimization."
		ewarn "This will result in your build taking at least twice as long as before."
	fi
	append-cppflags "-DTOR_BROWSER_DATA_IN_HOME_DIR"
}

pkg_pretend() {
	# Ensure we have enough disk space to compile
	if use pgo || use debug || use test ; then
		CHECKREQS_DISK_BUILD="8G"
	else
		CHECKREQS_DISK_BUILD="4G"
	fi
	check-reqs_pkg_setup
}

src_prepare() {
	local PATCHES=(
		"${FILESDIR}"/${PN}-profiledir.patch
		"${WORKDIR}"/firefox
	)

	eapply --directory="${WORKDIR}/firefox" \
		"${FILESDIR}"/1002_add_gentoo_preferences.patch

	rm -f \
		"${WORKDIR}"/firefox/2007_fix_nvidia_latest.patch \
		"${WORKDIR}"/firefox/2003_fix_sandbox_prlimit64.patch

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

	default
	if use rust; then
		eapply --ignore-whitespace "${FILESDIR}"/${PN}-cargo.patch
		find -type f -name Cargo.lock -delete
		sed -e 's:MOZ_CARGO_SUPPORTS_FROZEN:&_:' -i config/rules.mk
		sed -e '/mp4parse_capi =/s:= .*:= "0.10.1":' \
			-i toolkit/library/rust/shared/Cargo.toml
		sed -e '/cbindgen/,/\[/s:0.4.3:0.5.2:' \
			-i "${ECARGO_VENDOR}"/mp4parse_capi-0.10.1/Cargo.toml
		mv -f "${ECARGO_VENDOR}"/* third_party/rust/
	fi

	# Autotools configure is now called old-configure.in
	# This works because there is still a configure.in that happens to be for the
	# shell wrapper configure script
	eautoreconf old-configure.in

	# Must run autoconf in js/src
	cd "${S}"/js/src || die
	eautoconf old-configure.in

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

	# enable JACK, bug 600002
	mozconfig_use_enable jack

	use eme-free && mozconfig_annotate '+eme-free' --disable-eme

	# Add full relro support for hardened
	use hardened && append-ldflags "-Wl,-z,relro,-z,now"

	# Only available on mozilla-overlay for experimentation -- Removed in Gentoo repo per bug 571180
	#use egl && mozconfig_annotate 'Enable EGL as GL provider' --with-gl-provider=EGL

	# Setup api key for location services
	echo -n "${_google_api_key}" > "${S}"/google-api-key
	mozconfig_annotate '' --with-google-api-keyfile="${S}/google-api-key"

	mozconfig_annotate '' --enable-extensions="${MEXTENSIONS}"

	mozconfig_use_enable rust

	# Allow for a proper pgo build
	if use pgo; then
		echo "mk_add_options PROFILE_GEN_SCRIPT='EXTRA_TEST_ARGS=10 \$(MAKE) -C \$(MOZ_OBJDIR) pgo-profile-run'" >> "${S}"/.mozconfig
	fi

	# Other ff-specific settings
	mozconfig_annotate '' --with-default-mozilla-five-home=${MOZILLA_FIVE_HOME}

	echo "mk_add_options MOZ_OBJDIR=${BUILD_OBJ_DIR}" >> "${S}"/.mozconfig
	echo "mk_add_options XARGS=/usr/bin/xargs" >> "${S}"/.mozconfig

	# Rename the install directory and the executable
	mozconfig_annotate 'torbrowser' --libdir="${EPREFIX}"/usr/$(get_libdir)/${PN}
	mozconfig_annotate 'torbrowser' --with-app-name=torbrowser
	mozconfig_annotate 'torbrowser' --with-app-basename=torbrowser
	mozconfig_annotate 'torbrowser' --disable-tor-browser-update
	mozconfig_annotate 'torbrowser' --with-tor-browser-version=${TOR_PV}
	mozconfig_annotate 'torbrowser' --disable-tor-browser-data-outside-app-dir

	mozconfig_annotate 'torbrowser' --without-system-nspr
	mozconfig_annotate 'torbrowser' --without-system-nss

	# Finalize and report settings
	mozconfig_final

	if [[ $(gcc-major-version) -lt 4 ]]; then
		append-cxxflags -fno-stack-protector
	fi

	# workaround for funky/broken upstream configure...
	SHELL="${SHELL:-${EPREFIX%/}/bin/bash}" \
	emake -f client.mk configure
	pax-mark E "${BUILD_OBJ_DIR}"/_virtualenv/bin/${EPYTHON}
}

src_compile() {
	if use pgo; then
		addpredict /root
		addpredict /etc/gconf
		# Reset and cleanup environment variables used by GNOME/XDG
		gnome2_environment_reset

		# Firefox tries to use dri stuff when it's run, see bug 380283
		shopt -s nullglob
		cards=$(echo -n /dev/dri/card* | sed 's/ /:/g')
		if test -z "${cards}"; then
			cards=$(echo -n /dev/ati/card* /dev/nvidiactl* | sed 's/ /:/g')
			if test -n "${cards}"; then
				# Binary drivers seem to cause access violations anyway, so
				# let's use indirect rendering so that the device files aren't
				# touched at all. See bug 394715.
				export LIBGL_ALWAYS_INDIRECT=1
			fi
		fi
		shopt -u nullglob
		[[ -n "${cards}" ]] && addpredict "${cards}"

		MOZ_MAKE_FLAGS="${MAKEOPTS}" SHELL="${SHELL:-${EPREFIX%/}/bin/bash}" \
		virtx emake -f client.mk profiledbuild || die "virtx emake failed"
	else
		MOZ_MAKE_FLAGS="${MAKEOPTS}" SHELL="${SHELL:-${EPREFIX%/}/bin/bash}" \
		emake -f client.mk realbuild
	fi

}

src_install() {
	MOZILLA_FIVE_HOME="/usr/$(get_libdir)/${PN}/${PN}"

	cd "${BUILD_OBJ_DIR}" || die

	# Pax mark xpcshell for hardened support, only used for startupcache creation.
	pax-mark m "${BUILD_OBJ_DIR}"/dist/bin/xpcshell

	# Add an empty default prefs for mozconfig-3.eclass
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

	MOZ_MAKE_FLAGS="${MAKEOPTS}" SHELL="${SHELL:-${EPREFIX%/}/bin/bash}" \
	emake DESTDIR="${D}" install

	# Install icons and .desktop for menu entry
	local size sizes icon_path
	sizes="16 24 32 48 256"
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
	pax-mark m "${ED}"${MOZILLA_FIVE_HOME}/{${PN},${PN}-bin,plugin-container}

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
	xdg_desktop_database_update
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
