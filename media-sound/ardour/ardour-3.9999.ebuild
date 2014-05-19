# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

PLOCALES="
cs de el en_GB es fr it nn pl pt pt_PT ru sv zh
"
inherit fdo-mime gnome2-utils waf-utils l10n git-r3

DESCRIPTION="Digital Audio Workstation"
HOMEPAGE="http://ardour.org/"
EGIT_REPO_URI="git://git.ardour.org/ardour/ardour.git"

LICENSE="GPL-2"
SLOT="3"
KEYWORDS="~amd64 ~x86"
IUSE="bindist bundled-libs c++0x custom-cflags debug doc lv2 nls osc phone-home sse wiimote"

RDEPEND="
	dev-cpp/libgnomecanvasmm
	dev-libs/libsigc++
	dev-libs/libxml2
	media-libs/alsa-lib
	media-libs/aubio
	media-libs/flac
	media-libs/fontconfig
	osc? ( media-libs/liblo )
	media-libs/liblrdf
	media-libs/libogg
	media-libs/libsamplerate
	media-libs/libsndfile
	media-sound/jack-audio-connection-kit
	!bundled-libs? (
		media-libs/vamp-plugin-sdk
		media-libs/taglib
		media-libs/rubberband
		media-libs/libltc
	)
	net-misc/curl
	sci-libs/fftw
	sys-apps/util-linux
	lv2? (
		media-libs/suil
		media-libs/lilv
	)
	wiimote? (
		net-wireless/bluez
		app-misc/cwiid
	)
"
DEPEND="
	${RDEPEND}
	dev-libs/boost
	nls? ( sys-devel/gettext )
	doc? ( app-doc/doxygen )
"

my_use() {
	usex $1 --${2:-${1}} --no-${2:-${1}}
}

my_lcmsg() {
	local d
	for d in gtk2_ardour libs/ardour libs/gtkmm2ext; do
		rm -f ${d}/po/${1}.po
	done
}

src_prepare() {
	epatch "${FILESDIR}"/${PN}${SLOT}*.diff
	use nls && l10n_for_each_disabled_locale_do my_lcmsg
	use custom-cflags && sed -i wscript \
		-e 's:\(prepend_opt_flags = \)True:\1False:'
}

src_configure() {
	local wafargs=(
		--configdir=${EPREFIX}/etc
		--noconfirm
		--versioned
		--freedesktop
		$(my_use lv2)
		$(my_use nls)
		$(my_use phone-home)
		$(my_use sse fpu-optimization)
	)
	use bindist && wafargs+=(--freebie)
	use debug || wafargs+=(--optimize)
	use c++0x && wafargs+=(--cxx11)
	use bundled-libs || wafargs+=(--use-external-libs)
	use doc && wafargs+=(--docs)

	waf-utils_src_configure "${wafargs[@]}"
}

src_compile() {
	waf-utils_src_compile
	use nls && "${S}"/waf --jobs=$(makeopts_jobs) i18n || die "i18n build failed"
}

src_install() {
	waf-utils_src_install
	newicon icons/icon/ardour_icon_mac.png ${PN}${SLOT}.png
	newmenu gtk2_ardour/ardour3.desktop.in ${PN}${SLOT}.desktop
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
	gnome2_icon_cache_update
}

pkg_postrm() {
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
	gnome2_icon_cache_update
}
