# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit subversion toolchain-funcs

DESCRIPTION="x264 is a free library for encoding H264/AVC video streams"
HOMEPAGE="http://www.videolan.org/x264.html"
ESVN_REPO_URI="svn://svn.videolan.org/${PN}/trunk"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="X mp4 sdl threads gtk"

RDEPEND="mp4? || ( media-video/gpac-cvs media-video/gpac )
	X? ( x11-libs/libX11 )
	gtk? ( >=x11-libs/gtk+-2.6.0 )
	sdl? ( media-libs/libsdl )"
DEPEND="${RDEPEND}
	dev-lang/nasm"

src_unpack() {
	subversion_src_unpack
	cd ${S}

	REVISION="$(svnversion \
		${ESVN_STORE_DIR}/${ESVN_PROJECT}/${ESVN_REPO_URI##*/})"
	sed -i "s:^VER=.*:VER=${REVISION}:" version.sh

	sed -i 's:gpac_static:gpac:; s:/local::' configure
	sed -i 's:-lintl::; s,\(all:.*\)\$(TEST_BIN) \(.*\),\1\2,' gtk/Makefile
}

src_compile() {
	./configure\
		--enable-pic \
		--enable-shared \
		`use_enable X visualize` \
		`use_enable threads pthread` \
		`use_enable mp4 mp4-output`\
		--extra-cflags="${CFLAGS}"\
		--extra-ldflags="$LDFLAGS" || die

	einfo "Make lib and CLI encoder"
	make || die
	einfo "Make GTK+ frontend"
	use gtk && make -C gtk || die
	einfo "Make avc2avi"
	echo `tc-getCC` $CFLAGS $LDFLAGS -o avc2avi tools/avc2avi.c
	`tc-getCC` $CFLAGS $LDFLAGS -o avc2avi tools/avc2avi.c
	if use sdl; then
		einfo "Make xyuv"
		echo `tc-getCC` $CFLAGS $LDFLAGS -o xyuv tools/xyuv.c `sdl-config --libs`
		`tc-getCC` $CFLAGS $LDFLAGS -o xyuv tools/xyuv.c `sdl-config --libs`
	fi

	use threads && sed -i 's:\(^Libs.*\) :\1 -lpthread :' x264.pc
	use X && echo "Requires: x11" >> x264.pc
}

src_test() {
	:
#	make checkasm || die
#	./checkasm || die
}

src_install() {
	make DESTDIR=${D} install || die
	use gtk && make DESTDIR=${D} -C gtk install || die
	dobin x264 avc2avi
	use sdl && dobin xyuv
	dodoc AUTHORS doc/*.txt tools/*.{pl,sh}
}
