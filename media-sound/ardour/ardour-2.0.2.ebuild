# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/ardour/ardour-0.99.3.ebuild,v 1.1 2006/05/13 17:11:21 eldad Exp $

inherit flag-o-matic

DESCRIPTION="multi-track hard disk recording software"
HOMEPAGE="http://ardour.org/"
SRC_URI="
	http://ardour.org/files/releases/${P}.tar.bz2
	mirror://gentoo/libsndfile-1.0.17+flac-1.1.3.patch.bz2
"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="nls debug mmx 3dnow sse fftw osc vst ladspa external-libs"

RDEPEND="
	>=media-libs/liblrdf-0.3.6
	>=media-libs/raptor-1.2.0
	>=media-libs/libsamplerate-0.0.14
	fftw? ( =sci-libs/fftw-3* )
	>=media-sound/jack-audio-connection-kit-0.100.0
	>=dev-libs/libxml2-2.5.7
	dev-libs/libxslt
	media-libs/flac
	osc? ( media-libs/liblo )
	external-libs? (
		=dev-libs/libsigc++-2*
		dev-cpp/libgnomecanvasmm
		media-libs/libsoundtouch
		media-libs/libsndfile
	)
	ladspa? ( >=media-libs/ladspa-sdk-1.12 )
"
DEPEND="
	${RDEPEND}
	dev-util/pkgconfig
	>=dev-util/scons-0.96.1
	nls? ( sys-devel/gettext )
"

src_unpack() {
	unpack ${A}
	cd ${S}

	epatch "${FILESDIR}"/${PN}-[c-p]*.diff

	# handle gtkmm accessibility flag
	built_with_use dev-cpp/gtkmm accessibility || \
		sed -i "s:atkmm-1.6:gtkmm-2.4:" SConstruct

	# make bundled sndfile build w/ flac-1.1.3+
	if use !external-libs; then
		cd libs/libsndfile
		epatch "${WORKDIR}"/libsndfile-1.0.17+flac-1.1.3.patch
	fi
}

src_compile() {
	append-flags -fno-strict-aliasing
	# Required for scons to "see" intermediate install location
	mkdir -p ${D}

	local myconf="PREFIX=/usr DESTDIR=${D}"
	! use external-libs; myconf="${myconf} SYSLIBS=$?"
	! use debug; myconf="${myconf} DEBUG=$?"
	! use nls; myconf="${myconf} NLS=$?"
	! use fftw; myconf="${myconf} FFT_ANALYSIS=$?"
	! use osc; myconf="${myconf} LIBLO=$?"
	! use vst; myconf="${myconf} VST=$?"
	if use mmx || use 3dnow || use sse; then
		use mmx && _mmx="-mmmx"
		use 3dnow && _3dnow="-m3dnow"
		use sse && _sse="-msse -DBUILD_SSE_OPTIMIZATIONS"
		append-flags ${_mmx} ${_3dnow} ${_sse} -DARCH_X86
	fi

	scons \
		${myconf} || die "make failed"
}

src_install() {
	scons install || die "make install failed"

	dodoc DOCUMENTATION/{AUTHORS*,CONTRIBUTORS*,FAQ,README*,TODO,TRANSLATORS}
	doman DOCUMENTATION/ardour.1
}
