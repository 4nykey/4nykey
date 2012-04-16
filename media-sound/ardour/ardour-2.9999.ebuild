# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/ardour/ardour-2.8.12.ebuild,v 1.2 2011/09/28 22:48:16 ssuominen Exp $

EAPI=4
inherit eutils toolchain-funcs fdo-mime gnome2-utils scons-utils subversion

DESCRIPTION="Digital Audio Workstation"
HOMEPAGE="http://ardour.org/"
ESVN_REPO_URI="http://subversion.ardour.org/svn/ardour2/branches/2.0-ongoing"
ESVN_PATCHES="${PN}-*.diff"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="
nls debug sse fftw osc ladspa bundled-libs usb curl lv2 gnome soundtouch
"

RDEPEND="
	media-libs/liblrdf
	media-libs/libsamplerate
	fftw? ( sci-libs/fftw:3.0 )
	media-sound/jack-audio-connection-kit
	dev-libs/libxml2
	dev-libs/libxslt
	osc? ( media-libs/liblo )
	!bundled-libs? (
		dev-libs/libsigc++:2
		dev-cpp/libgnomecanvasmm
		soundtouch? ( media-libs/libsoundtouch )
		!soundtouch? ( media-libs/rubberband )
		media-libs/libsndfile
		media-libs/vamp-plugin-sdk
		media-libs/aubio
	)
	ladspa? ( media-libs/ladspa-sdk )
	usb? ( dev-libs/libusb )
	curl? ( net-misc/curl )
	lv2? ( media-libs/slv2 )
	media-libs/alsa-lib
"
DEPEND="
	${RDEPEND}
	dev-libs/boost
	dev-util/pkgconfig
	nls? ( sys-devel/gettext )
	usb? ( virtual/os-headers )
"

src_prepare() {
	[[ -z ${ESVN_WC_REVISION} ]] && subversion_wc_info
	subversion_src_prepare
	mkdir -p "${D}"
}

src_compile() {
	tc-export CC CXX
	escons \
		PREFIX=/usr \
		DESTDIR="${D}" \
		$(use_scons !bundled-libs SYSLIBS) \
		$(use_scons debug DEBUG) \
		$(use_scons nls NLS) \
		$(use_scons fftw FFT_ANALYSIS) \
		$(use_scons !soundtouch RUBBERBAND) \
		$(use_scons osc LIBLO) \
		$(use_scons usb SURFACES) \
		$(use_scons sse FPU_OPTIMIZATION) \
		$(use_scons curl FREESOUND) \
		$(use_scons lv2 LV2) \
		FREEDESKTOP=1 \
		VST=0 \
		CMT=0 \
		GTK=1 \
		KSI=1
}

src_install() {
	escons install

	doman ardour.1
}

pkg_postinst() {
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
	use gnome && gnome2_icon_cache_update
}

pkg_postrm() {
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
	use gnome && gnome2_icon_cache_update
}
