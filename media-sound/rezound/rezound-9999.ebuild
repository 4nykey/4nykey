# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/rezound/rezound-0.12.0_beta.ebuild,v 1.3 2005/09/09 13:19:09 flameeyes Exp $

inherit cvs autotools

DESCRIPTION="Sound editor and recorder"
HOMEPAGE="http://rezound.sourceforge.net"
SRC_URI="mirror://gentoo/${PN}-0.12.2_beta-patches.tar.bz2"
ECVS_SERVER="rezound.cvs.sourceforge.net:/cvsroot/rezound"
ECVS_MODULE="rezound"
S="${WORKDIR}/${ECVS_MODULE}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="
16bittmp alsa flac jack nls oss portaudio soundtouch vorbis ladspa lame cdr
audiofile fftw
"

DEPEND="
	fftw? ( =sci-libs/fftw-2* )
	>=x11-libs/fox-1.2.4
	audiofile? ( >=media-libs/audiofile-0.2.3 )
	ladspa? ( >=media-libs/ladspa-sdk-1.12
		>=media-libs/ladspa-cmt-1.15 )
	alsa? ( >=media-libs/alsa-lib-1.0 )
	flac? ( >=media-libs/flac-1.1.0 )
	jack? ( media-sound/jack-audio-connection-kit )
	portaudio? ( >=media-libs/portaudio-18 )
	soundtouch? ( >=media-libs/libsoundtouch-1.2.1 )
	vorbis? ( media-libs/libvorbis )
"
RDEPEND="
	${DEPEND}
	lame? ( >=media-sound/lame-3.92 )
	cdr? ( app-cdr/cdrdao )
"
DEPEND="
	${DEPEND}
	oss? ( virtual/os-headers )
	sys-devel/bison
	sys-devel/flex
	sys-devel/gettext
"

src_unpack() {
	unpack ${A}
	cvs_src_unpack
	cd "${S}"

	epatch "${WORKDIR}"/[17]0_*.patch

	epatch "${FILESDIR}"/${PN}-*.diff
	sed -i "/^CXXFLAGS/d" configure.ac

	autopoint --force || die
	AT_M4DIR="config/m4" eautoreconf
}

src_compile() {
	use 16bittmp && local sampletype="int16"

	econf \
		$(use_enable oss) \
		$(use_enable alsa) \
		$(use_enable alsa alsatest) \
		$(use_enable portaudio) \
		$(use_enable jack) \
		$(use_enable audiofile) \
		$(use_enable audiofile audiofiletest) \
		$(use_enable vorbis) \
		$(use_enable vorbis oggtest) \
		$(use_enable vorbis vorbistest) \
		$(use_enable flac) \
		$(use_enable flac libFLACtest) \
		$(use_enable flac libFLACPPtest) \
		$(use_enable fftw) \
		$(use_enable ladspa) \
		$(use_enable soundtouch) \
		$(use_enable soundtouch soundtouch-check) \
		$(use_enable nls) \
		--enable-internal-sample-type=${sampletype:-float} \
		--enable-largefile \
		|| die "configure failed"

	# eh?
	make -C src/frontend_fox CFOXIcons.o
	emake || die "make failed"
}

src_install() {
	make DESTDIR="${D}" install || die "make install failed"

	# remove wrong doc directory
	rm -rf ${D}/usr/doc/${PN}
	dodoc docs/{AUTHORS,NEWS,README*}
	dodoc docs/{TODO_FOR_USERS_TO_READ,*.txt}

	docinto code
	dodoc docs/code/*
	make_desktop_entry rezound "Rezound" /usr/share/rezound/icon_logo_32.gif "AudioVideo"
}
