# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/ardour/ardour-2.8.7.ebuild,v 1.2 2010/05/06 11:06:53 ssuominen Exp $

EAPI=2
inherit eutils toolchain-funcs fdo-mime gnome2-utils subversion

DESCRIPTION="Digital Audio Workstation"
HOMEPAGE="http://ardour.org/"
ESVN_REPO_URI="http://subversion.ardour.org/svn/ardour2/branches/2.0-ongoing"

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
	dev-util/scons
	nls? ( sys-devel/gettext )
	usb? ( virtual/os-headers )
"

src_prepare() {
	[[ -z ${ESVN_WC_REVISION} ]] && subversion_wc_info
	epatch "${FILESDIR}"/${PN}-*.diff
	mkdir -p "${D}"
}

src_compile() {
	tc-export CC CXX
	scons ${MAKEOPTS} \
		PREFIX=/usr \
		DESTDIR="${D}" \
		FREEDESKTOP=1 \
		VST=0 \
		CMT=0 \
		GTK=1 \
		KSI=1 \
		$(use bundled-libs; echo SYSLIBS=$?) \
		$(use !debug; echo DEBUG=$?) \
		$(use !nls; echo NLS=$?) \
		$(use !fftw; echo FFT_ANALYSIS=$?) \
		$(use soundtouch; echo RUBBERBAND=$?) \
		$(use !osc; echo LIBLO=$?) \
		$(use !usb; echo SURFACES=$?) \
		$(use !sse; echo FPU_OPTIMIZATION=$?) \
		$(use !curl; echo FREESOUND=$?) \
		$(use !lv2; echo LV2=$?) \
		|| die
}

src_install() {
	scons install || die

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
