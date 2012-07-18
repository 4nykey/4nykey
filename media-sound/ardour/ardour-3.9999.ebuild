# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit fdo-mime gnome2-utils waf-utils subversion

DESCRIPTION="Digital Audio Workstation"
HOMEPAGE="http://ardour.org/"
ESVN_REPO_URI="http://subversion.ardour.org/svn/ardour2/branches/3.0"
ESVN_PATCHES="${PN}${SLOT}-*.diff"

LICENSE=""
SLOT="3"
KEYWORDS="~amd64"
IUSE="bindist debug lv2 nls sse"

RDEPEND="
	dev-cpp/libgnomecanvasmm
	dev-libs/libsigc++
	dev-libs/libxml2
	media-libs/alsa-lib
	media-libs/aubio
	media-libs/flac
	media-libs/fontconfig
	media-libs/liblrdf
	media-libs/libogg
	media-libs/libsamplerate
	media-libs/libsndfile
	media-sound/jack-audio-connection-kit
	net-misc/curl
	sci-libs/fftw
	sys-apps/util-linux
	lv2? (
		media-libs/suil
		media-libs/lilv
	)
"
DEPEND="
	${RDEPEND}
	dev-libs/boost
"

my_use() {
	usex $1 --$1 --no-$1
}

src_prepare() {
	[[ -z ${ESVN_WC_REVISION} ]] && subversion_wc_info
	subversion_src_prepare
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
