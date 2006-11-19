# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit subversion autotools

DESCRIPTION="ffmpeg2theora - simple OggTheora encoder, transcodes all codecs/formats supported by ffmpeg."
HOMEPAGE="http://www.v2v.cc/~j/ffmpeg2theora"
ESVN_REPO_URI="http://svn.xiph.org/experimental/j/ffmpeg2theora-exp"
ESVN_BOOTSTRAP="eautoreconf"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

RDEPEND="
	media-libs/libtheora-exp
	media-video/ffmpeg
	>=media-libs/libogg-1.1.0
	>=media-libs/libvorbis-1.0.1
"
DEPEND="
	${RDEPEND}
"

pkg_setup() {
	if built_with_use media-video/ffmpeg theora; then
		eerror "No-go. emerge ffmpeg with USE="-theora""
		die "ffmpeg must be built without theora in use flags"
	fi
}

src_install() {
	newbin ffmpeg2theora ffmpeg2theora-exp
	if has_version '>=media-video/kino-0.7.1'; then
		exeinto /usr/share/kino/scripts/exports
		doexe kino_export/ffmpeg2theora.sh
	fi
	dodoc AUTHORS ChangeLog TODO README
}
