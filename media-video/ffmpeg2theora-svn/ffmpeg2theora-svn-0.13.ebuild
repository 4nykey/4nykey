# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils subversion

DESCRIPTION="ffmpeg2theora - simple OggTheora encoder, transcodes all codecs/formats supported by ffmpeg."
HOMEPAGE="http://www.v2v.cc/~j/ffmpeg2theora"
ESVN_REPO_URI="http://svn.xiph.org/trunk/ffmpeg2theora"
#SRC_URI="${HOMEPAGE}/${P}.tar.bz2"

LICENSE="xiph"
SLOT="0"
KEYWORDS="x86 amd64 ppc sparc alpha hppa"
IUSE="static"

DEPEND=">=media-libs/libtheora-1.0_alpha4
	|| ( >=media-video/ffmpeg-0.4.9_p20050226-r1
		media-video/ffmpeg-cvs )
	>=media-libs/libogg-1.1.0
	>=media-libs/libvorbis-1.0.1
	>=sys-devel/automake-1.6"

src_unpack() {
	#unpack ${A}
	subversion_src_unpack
	cd ${S}
	#epatch ${FILESDIR}/config.patch
	sed -i 's: no-dist-gzip::; s:-static ::' Makefile.am
	einfo "Running autoreconf"
	WANT_AUTOMAKE=1.7 autoreconf -i > /dev/null || die 
}

src_compile() {
	econf \
		`use_enable static` || die
	emake || die
}

src_install() {
	dobin ffmpeg2theora
	if has_version '>=media-video/kino-0.7.1'; then
		exeinto /usr/share/kino/scripts/exports
		doexe kino_export/ffmpeg2theora.sh
	fi
	dodoc AUTHORS ChangeLog COPYING INSTALL TODO README
}
