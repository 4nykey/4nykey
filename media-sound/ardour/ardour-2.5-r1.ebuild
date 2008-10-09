# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/ardour/ardour-2.4.1.ebuild,v 1.2 2008/04/20 16:54:45 aballier Exp $

EAPI="2"

inherit toolchain-funcs flag-o-matic fdo-mime gnome2-utils

DESCRIPTION="multi-track hard disk recording software"
HOMEPAGE="http://ardour.org/"
SRC_URI="
	http://ardour.org/files/releases/${P}.tar.bz2
	!external-libs? ( mirror://gentoo/libsndfile-1.0.17+flac-1.1.3.patch.bz2 )
"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="nls debug sse fftw osc ladspa external-libs usb curl lv2 gnome"

RDEPEND="
	media-libs/aubio
	>=media-libs/liblrdf-0.4.0
	>=media-libs/raptor-1.4.2
	>=media-libs/libsamplerate-0.1.0
	fftw? ( =sci-libs/fftw-3* )
	>=media-sound/jack-audio-connection-kit-0.101.1
	>=dev-libs/libxml2-2.6.0
	dev-libs/libxslt
	osc? ( media-libs/liblo )
	>=x11-libs/gtk+-2.8.1
	external-libs? (
		=dev-libs/libsigc++-2*
		dev-cpp/libgnomecanvasmm
		media-libs/libsoundtouch
		media-libs/libsndfile
	)
	ladspa? ( >=media-libs/ladspa-sdk-1.12 )
	usb? ( dev-libs/libusb )
	flac? ( media-libs/flac )
	curl? ( net-misc/curl )
	lv2? ( >=media-libs/slv2-0.6 )
	media-libs/alsa-lib[midi]
"
DEPEND="
	${RDEPEND}
	dev-libs/boost
	dev-util/pkgconfig
	>=dev-util/scons-0.96.1
	nls? ( sys-devel/gettext )
	usb? ( virtual/os-headers )
"

src_unpack() {
	unpack ${A}
	cd ${S}

	# handle gtkmm accessibility flag
	built_with_use dev-cpp/gtkmm accessibility || \
		sed -i SConstruct -e "s:atkmm-1.6:gtkmm-2.4:"

	sed -i SConstruct -e 's:libSoundTouch:soundtouch-1.0:'

	# Required for scons to "see" intermediate install location
	mkdir -p ${D}

	epatch "${FILESDIR}"/${PN}-*.diff
	if use !external-libs; then
		cd libs/libsndfile
		cp "${FILESDIR}"/configure.ac .
		epatch "${WORKDIR}"/libsndfile-1.0.17+flac-1.1.3.patch
	fi
}

teh_conf() {
	use !${1}; echo ${2}=$?
}

src_compile() {
	tc-export CC CXX

	# Avoid compiling x86 asm when building on amd64 without using sse
	# bug #186798
	use amd64 && append-flags "-DUSE_X86_64_ASM"

	append-flags -fno-strict-aliasing

	scons \
		PREFIX=/usr \
		VST=0 \
		CMT=0 \
		$(teh_conf external-libs SYSLIBS) \
		$(teh_conf debug DEBUG) \
		$(teh_conf nls NLS) \
		$(teh_conf fftw FFT_ANALYSIS) \
		$(teh_conf osc LIBLO) \
		$(teh_conf usb SURFACES) \
		$(teh_conf sse FPU_OPTIMIZATION) \
		$(teh_conf curl FREESOUND) \
		$(teh_conf lv2 LV2) \
		|| die "make failed"
}

src_install() {
	scons \
		DESTDIR=${D} \
		FREEDESKTOP=1 \
		install || die "make install failed"

	dodoc DOCUMENTATION/*
	doman DOCUMENTATION/ardour.1
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
