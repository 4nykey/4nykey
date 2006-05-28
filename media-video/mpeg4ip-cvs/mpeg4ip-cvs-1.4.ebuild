# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /home/cvsroot/gentoo-x86/media-video/mpeg4ip/mpeg4ip-1.0.ebuild,v 1.5 2004/02/27 13:38:34 tester Exp $

inherit cvs autotools flag-o-matic

DESCRIPTION="MPEG 4 implementation library"

HOMEPAGE="http://www.mpeg4ip.net/"

ECVS_SERVER="mpeg4ip.cvs.sourceforge.net:/cvsroot/mpeg4ip"
ECVS_MODULE="mpeg4ip"

LICENSE="MPL-1.1 LGPL-2 GPL-2 LGPL-2.1 BSD UCL MPEG4"

SLOT="0"

KEYWORDS="~x86"

IUSE="crypt encode gtk ipv6 mmx static v4l2 xvid ffmpeg mpeg aac mp3 a52 mad x264 id3"

DEPEND="sys-devel/libtool
		sys-devel/autoconf
		>=sys-devel/automake-1.6
		gtk? ( >=x11-libs/gtk+-2 )
		mmx? ( >=dev-lang/nasm-0.98.19 )
		xvid? ( >=media-libs/xvid-1.0 )
		ffmpeg? || ( media-video/ffmpeg
			media-video/ffmpeg-svn )
		encode? (
			aac? ( >=media-libs/faac-1.1 )
			mp3? ( >=media-sound/lame-3.92 ) )
		a52? ( media-libs/a52dec )
		mpeg? ( media-libs/libmpeg2 )
		mad? ( media-libs/libmad )
		x264? ( media-libs/x264 )
		id3? ( media-libs/id3lib )
		media-libs/libsdl
		media-libs/libmpeg2"

S="${WORKDIR}/${PN/-cvs}"

src_unpack() {
	cvs_src_unpack
	cd ${S}
	epatch ${FILESDIR}/${PN}.patch
	epatch ${FILESDIR}/no_isompeg4.diff

	sed -i 's:fexceptions :fexceptions -fpermissive :' \
		server/mp4live/gui/Makefile.am
	eautoreconf || die
	touch bootstrapped
}

src_compile() {
	filter-ldflags -Wl,--as-needed
	local myconf
	if use encode && use v4l2; then
		myconf="${myconf} --enable-mp4live --enable-v4l2"
		myconf="${myconf} $(use_enable aac faac) $(use_enable mp3 mp3lame)"
		myconf="${myconf} $(use_enable xvid) $(use_enable x264)"
	else
		myconf="${myconf} --disable-mp4live --disable-v4l2"
		myconf="${myconf} --disable-faac --disable-mp3lame"
		myconf="${myconf} --disable-xvid --disable-x264"
	fi

	econf \
		--enable-player \
		--enable-server \
		--disable-warns-as-err \
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
