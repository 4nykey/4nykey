# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

PLOCALES="
cs de el es it nn pl ru sv zh
"
inherit fdo-mime gnome2-utils waf-utils l10n git-2

DESCRIPTION="Digital Audio Workstation"
HOMEPAGE="http://ardour.org/"
EGIT_REPO_URI="git://git.ardour.org/ardour/ardour.git"

LICENSE="GPL-2"
SLOT="3"
KEYWORDS="~amd64 ~x86"
IUSE="bindist +bundled-libs debug lv2 nls osc sse wiimote"

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
"

my_use() {
	usex $1 --$1 --no-$1
}

my_lcmsg() {
	local d
	for d in gtk2_ardour libs/gtkmm2ext; do
		msgfmt -c -o ${d}/po/${1}.{m,p}o
	done
	MOPREFIX="gtk2_ardour${SLOT}" domo gtk2_ardour/po/${1}.mo
	MOPREFIX="libardour${SLOT}" domo libs/gtkmm2ext/po/${1}.mo
}

src_prepare() {
	epatch "${FILESDIR}"/${PN}${SLOT}*.diff
	use !bundled-libs && epatch "${FILESDIR}"/${PN}${SLOT}-syslibs.patch
}

src_configure() {
	waf-utils_src_configure \
		$(use bindist && echo --freebie) \
		$(use debug || echo --optimize) \
		$(use sse || echo --no-fpu-optimization) \
		$(my_use lv2) \
		$(my_use nls) \
		--versioned \
		--freedesktop
}

src_install() {
	waf-utils_src_install
	newicon icons/icon/ardour_icon_mac.png ardour3.png
	newmenu gtk2_ardour/ardour3.desktop.in ardour3.desktop
	use nls && l10n_for_each_locale_do my_lcmsg
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
