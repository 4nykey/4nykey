# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit subversion autotools

DESCRIPTION="ffmpeg2theora - simple OggTheora encoder, transcodes all codecs/formats supported by ffmpeg."
HOMEPAGE="http://www.v2v.cc/~j/ffmpeg2theora"
ESVN_REPO_URI="http://svn.xiph.org/experimental/j/ffmpeg2theora-exp"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 amd64 ppc sparc alpha hppa"
IUSE=""

DEPEND="media-libs/libtheora-exp
	media-video/ffmpeg-cvs
	>=media-libs/libogg-1.1.0
	>=media-libs/libvorbis-1.0.1"

pkg_setup() {
	if built_with_use ffmpeg-cvs theora; then
		eerror "No-go. USE=-theora emerge ffmpeg"
		die
	fi
}

src_unpack() {
	subversion_src_unpack
	cd ${S}
	eautoreconf || die
}

src_install() {
	newbin ffmpeg2theora ffmpeg2theora-exp
	if has_version '>=media-video/kino-0.7.1'; then
		exeinto /usr/share/kino/scripts/exports
		doexe kino_export/ffmpeg2theora.sh
	fi
	dodoc AUTHORS ChangeLog TODO README
}
