# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit git toolchain-funcs

DESCRIPTION="x264 is a free library for encoding H264/AVC video streams"
HOMEPAGE="http://www.videolan.org/x264.html"
EGIT_REPO_URI="git://git.videolan.org/x264.git"
EGIT_PATCHES="${PN}-*.diff"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="X mp4 sdl threads gtk static"

RDEPEND="
	mp4? ( media-video/gpac )
	X? ( x11-libs/libX11 )
	gtk? ( >=x11-libs/gtk+-2.6.0 )
	sdl? ( media-libs/libsdl )
"
DEPEND="
	${RDEPEND}
	dev-lang/nasm
"

src_compile() {
	local myconf
	use X && myconf="--enable-visualize"

	# w/o debug configure adds '-s' to {c,ld}flags
	GIT_DIR="${EGIT_STORE_DIR}/${GIT_DIR}" \
	./configure\
		--prefix=/usr \
		--enable-pic \
		--enable-debug \
		--disable-avis-input \
		$(use_enable !static shared) \
		$(use_enable threads pthread) \
		$(use_enable mp4 mp4-output)\
		--extra-cflags="${CFLAGS}"\
		--extra-ldflags="$LDFLAGS" \
		${myconf} || die
	touch .depend

	emake || die
	echo $(tc-getCC) $CFLAGS $LDFLAGS -o avc2avi tools/avc2avi.c
	$(tc-getCC) $CFLAGS $LDFLAGS -o avc2avi tools/avc2avi.c

	use gtk && emake -C gtk || die

	if use sdl; then
		echo $(tc-getCC) $CFLAGS $LDFLAGS -o xyuv tools/xyuv.c $(sdl-config --libs)
		$(tc-getCC) $CFLAGS $LDFLAGS -o xyuv tools/xyuv.c $(sdl-config --libs)
	fi

	use X && echo "Requires: x11" >> x264.pc
}

src_test() {
	emake checkasm || die
	./checkasm || die
}

src_install() {
	emake DESTDIR=${D} install || die
	use gtk && emake DESTDIR=${D} -C gtk install || die
	dobin x264 avc2avi
	use sdl && dobin xyuv
	dodoc AUTHORS doc/*.txt tools/*.{pl,sh}
}
