# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/rezound/rezound-0.12.0_beta.ebuild,v 1.3 2005/09/09 13:19:09 flameeyes Exp $

inherit cvs autotools

DESCRIPTION="Sound editor and recorder"
HOMEPAGE="http://rezound.sourceforge.net"
ECVS_SERVER="rezound.cvs.sourceforge.net:/cvsroot/rezound"
ECVS_MODULE="rezound"
S="${WORKDIR}/${ECVS_MODULE}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="16bittmp alsa flac jack nls oss portaudio soundtouch vorbis ladspa lame
cdr"

COMMON_DEPS="
	=sci-libs/fftw-2*
	>=x11-libs/fox-1.2.4
	>=media-libs/audiofile-0.2.3
	ladspa? ( >=media-libs/ladspa-sdk-1.12
		>=media-libs/ladspa-cmt-1.15 )
	alsa? ( >=media-libs/alsa-lib-1.0 )
	flac? ( >=media-libs/flac-1.1.0 )
	jack? ( media-sound/jack-audio-connection-kit )
	portaudio? ( >=media-libs/portaudio-18 )
	soundtouch? ( >=media-libs/libsoundtouch-1.2.1 )
	vorbis? ( media-libs/libvorbis media-libs/libogg )
	oss? ( virtual/os-headers )
"

# optional packages (don't need to be installed during emerge):
RDEPEND="
	${COMMON_DEPS}
	lame? ( >=media-sound/lame-3.92 )
	cdr? ( app-cdr/cdrdao )
"

DEPEND="
	${COMMON_DEPS}
	sys-devel/bison
	sys-devel/flex
	sys-devel/gettext
"

src_unpack() {
	cvs_src_unpack
	cd ${S}

	epatch "${FILESDIR}"/fox-1.6.diff
	epatch "${FILESDIR}"/gcc41*.patch
	sed -i "/^CXXFLAGS/d" configure.ac

	autopoint --force || die
	AT_M4DIR="config/m4" eautoreconf
}

src_compile() {
	# following features can't be disabled if already installed:
	# -> flac, oggvorbis, soundtouch
	local sampletype=""
	use 16bittmp && sampletype="--enable-internal-sample-type=int16"
	use 16bittmp || sampletype="--enable-internal-sample-type=float"

	econf \
		$(use_enable alsa) \
		$(use_enable jack) \
		$(use_enable nls) \
		$(use_enable oss) \
		$(use_enable portaudio) \
		${sampletype} \
		$(use_enable ladspa) \
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
