# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/lives/lives-0.9.1.ebuild,v 1.3 2005/03/20 00:42:37 luckyduck Exp $

inherit flag-o-matic cvs

DESCRIPTION="Linux Video Editing System"

HOMEPAGE="http://www.xs4all.nl/~salsaman/lives"

#MY_PN=LiVES
#MY_P=${MY_PN}-${PV}

#SRC_URI="mirror://sourceforge/lives/${MY_P}-src.tar.bz2"
ECVS_SERVER="cvs.sourceforge.net:/cvsroot/lives"
S="${WORKDIR}/${PN/-cvs}"

LICENSE="GPL-2"

SLOT="0"

KEYWORDS="~x86"

IUSE="xmms matroska ogg theora libvisual sdl mjpegtools"

DEPEND=">=media-video/mplayer-0.90-r2
		>=media-gfx/imagemagick-5.5.6
		>=dev-lang/perl-5.8.0-r12
		>=x11-libs/gtk+-2.2.1
		media-libs/libsdl
		>=media-video/ffmpeg-0.4.8
		>=media-libs/jpeg-6b-r3
		>=media-sound/sox-12.17.3-r3
		xmms? ( >=media-sound/xmms-1.2.7-r20 )
		virtual/cdrtools
		theora? ( media-libs/libtheora )
		>=dev-lang/python-2.3.4
		matroska? || ( media-video/mkvtoolnix
					media-video/mkvtoolnix-svn )
		ogg? ( media-sound/ogmtools )
		mjpegtools? ( >=media-video/mjpegtools-1.6.2 )
		sdl? ( media-libs/libsdl )
		libvisual? ( >=media-libs/libvisual-0.2.0 )"

src_unpack() {
	ECVS_MODULE="lives" cvs_src_unpack
	ECVS_MODULE="lives-plugins" cvs_src_unpack
	mv ${WORKDIR}/lives-plugins ${S} || die
	cd ${S}
	WANT_AUTOMAKE=1.7 autoreconf --install --force || die
}

src_compile() {
	econf \
		$(use_enable libvisual) \
		$(use_enable sdl) \
		$(use_enable mjpegtools) || die "configure failed"
	emake || die "make failed"
}

src_install() {
	emake DESTDIR=${D} install || die
	dodoc AUTHORS CHANGELOG FEATURES GETTING.STARTED
}
