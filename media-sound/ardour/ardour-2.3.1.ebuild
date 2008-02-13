# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/ardour/ardour-0.99.3.ebuild,v 1.1 2006/05/13 17:11:21 eldad Exp $

inherit flag-o-matic versionator

DESCRIPTION="multi-track hard disk recording software"
HOMEPAGE="http://ardour.org/"
SRC_URI="
	http://ardour.org/files/releases/${P}.tar.bz2
	!external-libs? ( mirror://gentoo/libsndfile-1.0.17+flac-1.1.3.patch.bz2 )
"
S="${WORKDIR}/${PN}-$(get_version_component_range 1-2)"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="nls debug mmx 3dnow sse fftw osc ladspa external-libs usb"

RDEPEND="
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
		media-libs/vamp-plugin-sdk
	)
	ladspa? ( >=media-libs/ladspa-sdk-1.12 )
	usb? ( dev-libs/libusb )
	flac? ( media-libs/flac )
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
	use !${1}; myconf="${myconf} ${2}=$?"
}

src_compile() {
	append-flags -fno-strict-aliasing

	local myconf="PREFIX=/usr VST=0 CMT=0"
	teh_conf external-libs SYSLIBS
	teh_conf debug DEBUG
	teh_conf nls NLS
	teh_conf fftw FFT_ANALYSIS
	teh_conf osc LIBLO
	teh_conf usb SURFACES
	teh_conf sse FPU_OPTIMIZATION

	local _mmx _3dnow _sse
	use mmx && _mmx="-mmmx"
	use 3dnow && _3dnow="-m3dnow"
	use sse && _sse="-msse -mfpmath=sse -DUSE_XMMINTRIN"
	append-flags ${_mmx} ${_3dnow} ${_sse} -DARCH_X86

	scons \
		${myconf} || die "make failed"
}

src_install() {
	scons DESTDIR=${D} install || die "make install failed"

	dodoc DOCUMENTATION/{AUTHORS*,CONTRIBUTORS*,FAQ,README*,TODO,TRANSLATORS}
	doman DOCUMENTATION/ardour.1
}
