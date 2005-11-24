# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit subversion toolchain-funcs flag-o-matic

DESCRIPTION="x264 is a free library for encoding H264/AVC video streams"
HOMEPAGE="http://www.videolan.org/x264.html"
ESVN_REPO_URI="svn://svn.videolan.org/${PN}/trunk"
ESVN_PATCHES="gpac_shared.diff"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="X mp4 sdl threads test"

RDEPEND="mp4? ( media-video/gpac-cvs )
	X? ( virtual/x11 )
	sdl? ( media-libs/libsdl )"
DEPEND="${RDEPEND}
	dev-lang/nasm"

src_compile() {
	use X && DEP_LIBS=" -lX11"
	use threads && DEP_LIBS="${DEP_LIBS} -lpthread"

	./configure\
		`use_enable X visualize` \
		`use_enable threads pthread` \
		`use_enable mp4 mp4-output`\
		--extra-cflags="${CFLAGS}"\
		--extra-ldflags="$LDFLAGS"

	make || die
	`tc-getCC` $CFLAGS $LDFLAGS -o avc2avi tools/avc2avi.c
	use sdl && `tc-getCC` $CFLAGS $LDFLAGS -o xyuv tools/xyuv.c -lSDL
}

src_test() {
	make checkasm || die
	./checkasm || die
}

src_install() {
	newlib.a libx264.a libx264_static.a
	dobin x264 xyuv avc2avi
	insinto /usr/$(get_libdir)
	newins ${FILESDIR}/ld_script libx264.so
	newins ${FILESDIR}/ld_script libx264.a
	dosed "s:@DEP_LIBS@:${DEP_LIBS}:" /usr/$(get_libdir)/libx264.{so,a}
	insinto /usr/include
	doins x264.h
	dodoc AUTHORS COPYING doc/dct.txt TODO tools/*.{pl,sh}
}
