# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/ardour/ardour-0.99.3.ebuild,v 1.1 2006/05/13 17:11:21 eldad Exp $

inherit eutils subversion

DESCRIPTION="multi-track hard disk recording software"
HOMEPAGE="http://ardour.org/"
#SRC_URI="http://ardour.org/files/releases/${P/_/}.tar.bz2"
ESVN_REPO_URI="http://subversion.ardour.org/svn/ardour2/trunk"
ESVN_PATCHES="ardour-cflags.diff"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="nls debug sse altivec fftw osc vst ladspa"

RDEPEND=">=media-libs/liblrdf-0.3.6
	>=media-libs/raptor-1.2.0
	>=media-libs/libsamplerate-0.0.14
	fftw? ( =sci-libs/fftw-3* )
	>=media-sound/jack-audio-connection-kit-0.100.0
	>=dev-libs/libxml2-2.5.7
	dev-libs/libxslt
	media-libs/flac
	osc? ( media-libs/liblo )
	=dev-libs/libsigc++-2*
	dev-cpp/libgnomecanvasmm
	media-libs/libsoundtouch
	ladspa? ( >=media-libs/ladspa-sdk-1.12 )
	"

DEPEND="${RDEPEND}
	dev-util/pkgconfig
	>=dev-util/scons-0.96.1
	nls? ( sys-devel/gettext )"

src_compile() {
	# Required for scons to "see" intermediate install location
	mkdir -p ${D}

	local myconf="PREFIX=/usr DESTDIR=${D} SYSLIBS=1"
	! use altivec; myconf="${myconf} ALTIVEC=$?"
	! use debug; myconf="${myconf} ARDOUR_DEBUG=$?"
	! use nls; myconf="${myconf} NLS=$?" 
	! use fftw; myconf="${myconf} FFT_ANALYSIS=$?" 
	! use osc; myconf="${myconf} LIBLO=$?" 
	! use vst; myconf="${myconf} VST=$?" 

	cd ${S}
	scons \
		CCFLAGS="${CFLAGS}" \
		CXXFLAGS="${CXXFLAGS}" \
		${MAKEOPTS} \
		${myconf} || die "make failed"
}

src_install() {
	scons install || die "make install failed"

	dodoc DOCUMENTATION/*
}

pkg_postinst() {
	if use sse
	then
		einfo ""
		einfo "Start ardour with the -o argument to use the optimized SSE functions:"
		einfo ""
		einfo "	  ardour -o"
		einfo ""
	fi
}

