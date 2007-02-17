# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/transcode/transcode-1.0.2-r1.ebuild,v 1.6 2006/01/10 11:18:29 flameeyes Exp $

inherit libtool flag-o-matic cvs multilib autotools

DESCRIPTION="video stream processing tool"
HOMEPAGE="http://www.transcoding.org"
ECVS_SERVER="cvs.exit1.org:/cvstc"
ECVS_MODULE="transcode"
ECVS_USER="cvs"
#ECVS_BRANCH="new-module-system"
S="${WORKDIR}/${ECVS_MODULE}"
RESTRICT="test"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="
	X 3dnow a52 dv dvdread extrafilters mp3 fame truetype gtk imagemagick jpeg
	lzo mjpeg mmx network ogg vorbis quicktime sdl sse sse2 theora v4l2 xvid xml
	postproc x264 aac
"

RDEPEND="
	a52? ( >=media-libs/a52dec-0.7.4 )
	dv? ( >=media-libs/libdv-0.99 )
	dvdread? ( >=media-libs/libdvdread-0.9.0 )
	xvid? ( >=media-libs/xvid-1.0.2 )
	x264? ( || ( media-libs/x264 media-libs/x264-svn ) )
	mjpeg? ( >=media-video/mjpegtools-1.6.2-r3 )
	lzo? ( >=dev-libs/lzo-2 )
	fame? ( >=media-libs/libfame-0.9.1 )
	imagemagick? ( >=media-gfx/imagemagick-5.5.6.0 )
	media-libs/libexif
	mp3? ( >=media-sound/lame-3.93 )
	aac? ( media-libs/faac )
	sdl? ( media-libs/libsdl )
	quicktime? ( >=media-libs/libquicktime-0.9.3 )
	vorbis? ( media-libs/libvorbis )
	ogg? ( media-libs/libogg )
	theora? ( media-libs/libtheora )
	jpeg? ( media-libs/jpeg )
	gtk? ( =x11-libs/gtk+-1.2* )
	truetype? ( >=media-libs/freetype-2 )
	>=media-video/ffmpeg-0.4.9_p20050226-r3
	>=media-libs/libmpeg2-0.4.0b
	virtual/libiconv
	xml? ( dev-libs/libxml2 )
	X? ( x11-libs/libXaw x11-libs/libXv )
"
DEPEND="
	${RDEPEND}
	v4l2? ( >=virtual/os-headers-2.6.11 )
"

src_unpack() {
	cvs_src_unpack
	cd ${S}

	sed -i "s:\$(datadir)/doc/transcode:\$(datadir)/doc/${PF}:" \
		${S}/Makefile.am ${S}/docs/Makefile.am ${S}/docs/html/Makefile.am

	# don't use aux dir for autoconf junk
	sed -i '/AC_CONFIG_AUX_DIR/d' configure.in

	:> testsuite/Makefile.am

	eautoreconf || die
}

src_compile() {
	append-flags -DDCT_YUV_PRECISION=1
	filter-flags -momit-leaf-frame-pointer
	econf \
		$(use_enable mmx) \
		$(use_enable 3dnow) \
		$(use_enable sse) \
		$(use_enable sse2) \
		$(use_enable truetype freetype2) \
		$(use_enable v4l2 v4l) \
		$(use_enable xvid) \
		$(use_enable x264) \
		$(use_enable mp3 lame) \
		$(use_enable aac faac) \
		$(use_enable ogg) \
		$(use_enable vorbis) \
		$(use_enable theora) \
		$(use_enable dvdread libdvdread) \
		$(use_enable dv libdv) \
		$(use_enable quicktime libquicktime) \
		$(use_enable lzo) \
		$(use_enable a52) \
		$(use_enable xml libxml2) \
		$(use_enable mjpeg mjpegtools) \
		$(use_enable sdl) \
		$(use_enable gtk) \
		$(use_enable fame libfame) \
		$(use_enable imagemagick) \
		$(use_enable jpeg libjpeg) \
		$(use_with X x) \
		$(use_enable postproc libpostproc) \
		--with-mod-path=/usr/$(get_libdir)/transcode \
		--with-lzo-includes=/usr/include/lzo || die

	emake all || die
}

src_install () {
	make DESTDIR=${D} install || die

	#do not install the filters that make dvdrip hang unless we ask for them
	if ! use extrafilters ; then
	rm ${D}/usr/$(get_libdir)/transcode/filter_logo.*
	rm ${D}/usr/$(get_libdir)/transcode/filter_compare.*
	fi

	dodoc AUTHORS ChangeLog README TODO
}
