# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/ardour/ardour-0.99.3.ebuild,v 1.1 2006/05/13 17:11:21 eldad Exp $

inherit subversion flag-o-matic

DESCRIPTION="multi-track hard disk recording software"
HOMEPAGE="http://ardour.org/"
ESVN_REPO_URI="http://subversion.ardour.org/svn/ardour2/trunk"
ESVN_PATCHES="${PN}-*.diff"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="-*"
IUSE="nls debug mmx 3dnow sse fftw osc ladspa external-libs doc usb"
# usb is for tranzport (req libusb) and powermate (req linux/input.h)

RDEPEND="
	>=media-libs/liblrdf-0.3.6
	>=media-libs/raptor-1.2.0
	>=media-libs/libsamplerate-0.0.14
	fftw? ( =sci-libs/fftw-3* )
	>=media-sound/jack-audio-connection-kit-0.105.0
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
	usb? ( dev-libs/libusb )
"
DEPEND="
	${RDEPEND}
	dev-libs/boost
	dev-util/pkgconfig
	>=dev-util/scons-0.96.1
	nls? ( sys-devel/gettext )
	doc? ( app-text/xmlto )
	usb? ( virtual/os-headers )
"

src_unpack() {
	subversion_src_unpack
	[[ -z ${ESVN_WC_REVISION} ]] && subversion_wc_info

	cd ${S}
	sed -i svn_revision.h \
		-e "s:\([ =]*\"\)[0-9]\+:\1${ESVN_WC_REVISION}:"

	# handle gtkmm accessibility flag
	built_with_use dev-cpp/gtkmm accessibility || \
		sed -i "s:atkmm-1.6:gtkmm-2.4:" SConstruct

	append-flags -fno-strict-aliasing
	# Required for scons to "see" intermediate install location
	mkdir -p ${D}
}

src_compile() {
	# CMT is for anicomp support (animix.sf.net)
	local myconf="PREFIX=/usr DESTDIR=${D} VST=0 CMT=0"
	use !external-libs; myconf="${myconf} SYSLIBS=$?"
	use !debug; myconf="${myconf} DEBUG=$?"
	use !nls; myconf="${myconf} NLS=$?"
	use !fftw; myconf="${myconf} FFT_ANALYSIS=$?"
	use !osc; myconf="${myconf} LIBLO=$?"
	use !usb; myconf="${myconf} SURFACES=$?"
	if use mmx || use 3dnow || use sse; then
		use mmx && _mmx="-mmmx"
		use 3dnow && _3dnow="-m3dnow"
		use sse && _sse="-msse -DBUILD_SSE_OPTIMIZATIONS"
		append-flags ${_mmx} ${_3dnow} ${_sse} -DARCH_X86
	fi

	scons \
		${myconf} || die "make failed"
	use doc && make -C manual html
}

src_install() {
	scons install || die "make install failed"

	dodoc DOCUMENTATION/{AUTHORS*,CONTRIBUTORS*,FAQ,README*,TODO,TRANSLATORS}
	doman DOCUMENTATION/ardour.1
	use doc && dohtml -r manual/tmp/*
}
