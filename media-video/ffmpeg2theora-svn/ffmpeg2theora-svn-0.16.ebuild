# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit subversion autotools

DESCRIPTION="ffmpeg2theora - simple OggTheora encoder, transcodes all codecs/formats supported by ffmpeg."
HOMEPAGE="http://www.v2v.cc/~j/ffmpeg2theora"
ESVN_REPO_URI="http://svn.xiph.org/trunk/ffmpeg2theora"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 amd64 ppc sparc alpha hppa"
IUSE=""

DEPEND="!media-video/ffmpeg2theora
	>=media-libs/libtheora-1.0_alpha4
	|| ( >=media-video/ffmpeg-0.4.9_p20050226-r1
		media-video/ffmpeg-svn )
	>=media-libs/libogg-1.1.0
	>=media-libs/libvorbis-1.0.1"

src_unpack() {
	subversion_src_unpack
	cd ${S}
	eautoreconf || die
}

src_install() {
	dobin ffmpeg2theora
	if has_version '>=media-video/kino-0.7.1'; then
		exeinto /usr/share/kino/scripts/exports
		doexe kino_export/ffmpeg2theora.sh
	fi
	dodoc AUTHORS ChangeLog README TODO
}
