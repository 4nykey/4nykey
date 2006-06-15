# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /home/cvsroot/gentoo-x86/media-video/mpeg4ip/mpeg4ip-1.0.ebuild,v 1.5 2004/02/27 13:38:34 tester Exp $

inherit cvs autotools flag-o-matic

DESCRIPTION="MPEG 4 implementation library"

HOMEPAGE="http://www.mpeg4ip.net/"

ECVS_SERVER="mpeg4ip.cvs.sourceforge.net:/cvsroot/mpeg4ip"
ECVS_MODULE="mpeg4ip"
S="${WORKDIR}/${ECVS_MODULE}"

LICENSE="MPL-1.1 LGPL-2 GPL-2 LGPL-2.1 BSD UCL MPEG4"

SLOT="0"

KEYWORDS="~x86"

IUSE="crypt encode gtk ipv6 mmx static v4l2 xvid ffmpeg mpeg aac mp3 a52 mad
x264 id3 alsa sdl"

DEPEND="gtk? ( >=x11-libs/gtk+-2 )
		mmx? ( >=dev-lang/nasm-0.98.19 )
		xvid? ( >=media-libs/xvid-1.0 )
		ffmpeg? || ( media-video/ffmpeg-svn
			media-video/ffmpeg )
		encode? (
			aac? ( >=media-libs/faac-1.1 )
			mp3? ( >=media-sound/lame-3.92 ) )
		a52? ( media-libs/a52dec )
		mpeg? ( media-libs/libmpeg2 )
		mad? ( media-libs/libmad )
		x264? ( media-libs/x264 )
		id3? ( media-libs/id3lib )
		sdl? ( media-libs/libsdl )
		alsa? ( media-libs/alsa-lib )
		media-libs/libmpeg2"

src_unpack() {
	cvs_src_unpack
	cd ${S}
	epatch ${FILESDIR}/${PN/cvs/}*.diff
	use alsa && epatch ${FILESDIR}/${PN/cvs/}alsa.patch

	sed -i 's:\(-fexceptions\):\1 -fpermissive:' server/mp4live/gui/Makefile.am
	eautoreconf
	touch bootstrapped
}

src_compile() {
	filter-ldflags -Wl,--as-needed
	local myconf
	if use encode && use v4l2; then
		myconf="--enable-mp4live \
			--enable-v4l2 \
			$(use_enable alsa mp4live-alsa) \
			$(use_enable aac faac) \
			$(use_enable mp3 mp3lame)\
			$(use_enable xvid) \
			$(use_enable x264)"
	else
		myconf="--disable-mp4live \
			--disable-v4l2 \
			--disable-faac \
			--disable-mp3lame \
			--disable-xvid \
			--disable-x264"
	fi

	econf \
		--disable-warns-as-err \
		--enable-server \
		$(use_enable sdl player) \
		$(use_enable ipv6) \
		$(use_enable mmx) \
		$(use_enable ppc) \
		$(use_enable gtk gtk-glib) \
		$(use_enable gtk glibtest) \
		$(use_enable gtk gtktest) \
		$(use_enable a52 a52dec) \
		$(use_enable mad) \
		$(use_enable mpeg mpeg2dec) \
		$(use_enable id3 id3tags) \
		$(use_enable crypt ismacryp) \
		$(use_enable static) \
		${myconf} || die "configure failed"

	emake || die "emake failed"
}

src_install () {
	cd ${S}
	emake DESTDIR=${D} install || die "make install failed"
}
