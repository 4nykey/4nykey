# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit subversion confutils

DESCRIPTION="ffmpeg2theora - simple OggTheora encoder, transcodes all codecs/formats supported by ffmpeg."
HOMEPAGE="http://www.v2v.cc/~j/ffmpeg2theora"
ESVN_REPO_URI="http://svn.xiph.org/trunk/ffmpeg2theora"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

RDEPEND="
	media-libs/libtheora
	media-video/ffmpeg
	>=media-libs/libogg-1.1
	media-libs/libvorbis
"
DEPEND="
	${RDEPEND}
	dev-util/scons
	dev-util/pkgconfig
"

pkg_setup() {
	local ff_use="postproc swscaler vhook"
	for x in ${ff_use}; do
		built_with_use --missing true media-video/ffmpeg ${x} ||
		confutils_require_built_with_all media-video/ffmpeg ${ff_use}
	done
}

src_compile() {
	scons \
		prefix=/usr \
		APPEND_CCFLAGS="${CFLAGS}" \
		APPEND_LINKFLAGS="${LDFLAGS}" \
		|| die "build failed"
}

src_install() {
	dobin ffmpeg2theora
	doman ffmpeg2theora.1
	dodoc AUTHORS ChangeLog README TODO
}
