# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/lives/lives-0.9.1.ebuild,v 1.3 2005/03/20 00:42:37 luckyduck Exp $

inherit flag-o-matic cvs autotools

DESCRIPTION="LiVES is a Video Editing System"
HOMEPAGE="http://lives.sourceforge.net/"
ECVS_SERVER="lives.cvs.sourceforge.net:/cvsroot/lives"
S="${WORKDIR}/${PN}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="osc jack sdl mjpeg libvisual ieee1394 perl ffmpeg cdr transcode dv pdf
swf python mp3 dirac matroska x264 vorbis mpeg ogg theora"

COMMON_DEPS="
	>=x11-libs/gtk+-2.8.0
	>=media-libs/jpeg-6b-r3
	jack? ( media-sound/jack-audio-connection-kit )
	sdl? ( media-libs/libsdl )
	mjpeg? ( >=media-video/mjpegtools-1.6.2 )
	libvisual? ( >=media-libs/libvisual-0.2.0 )
	ieee1394? ( sys-libs/libraw1394 )
"
# optional runtime deps for lives-plugins (perl and python scripts)
RDEPEND="
	${COMMON_DEPS}
	media-video/mplayer
	media-sound/sox
	media-gfx/imagemagick
	cdr? ( virtual/cdrtools )
	perl? ( >=dev-lang/perl-5.8.0-r12
		ffmpeg? ( media-video/ffmpeg )
		transcode? ( media-video/transcode )
		dv? ( media-libs/libdv )
		pdf? ( virtual/ghostscript )
		swf? ( media-video/sswf )
	)
	python? ( >=dev-lang/python-2.3.4
		mp3? ( media-sound/lame )
		dirac? ( media-video/dirac )
		matroska? ( media-video/mkvtoolnix )
		x264? ( media-libs/x264 )
		vorbis? ( media-sound/vorbis-tools )
		mpeg? ( media-video/mjpegtools )
		ogg? ( media-sound/ogmtools )
		theora? ( media-libs/libtheora )
	)
"
DEPEND="
	${COMMON_DEPS}
	dev-util/pkgconfig
	>=sys-devel/gettext-0.12.1
"

src_unpack() {
	ECVS_MODULE="lives" cvs_src_unpack
	ECVS_MODULE="lives-plugins" cvs_src_unpack
	mv ${WORKDIR}/lives-plugins ${S} || die
	cd ${S}
	autopoint --force || die "autopoint failed"
	eautoreconf
}

src_compile() {
	use sdl || local myconf="${myconf} --disable-sdl"
	econf \
		$(use_enable osc OSC) \
		$(use_enable jack) $(use_enable jack jack-transport) \
		$(use_enable mjpeg mjpegtools) \
		$(use_enable libvisual) \
		$(use_enable ieee1394 dvgrab) \
		${myconf} || die "configure failed"
	emake || die "make failed"
}

src_install() {
	einstall MKINSTALLDIRS="${S}/mkinstalldirs" || die
	dodoc AUTHORS BUGS CHANGELOG FEATURES GETTING.STARTED NEWS README
}
