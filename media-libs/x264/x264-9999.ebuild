# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit toolchain-funcs git

DESCRIPTION="x264 is a free library for encoding H264/AVC video streams"
HOMEPAGE="http://www.videolan.org/x264.html"
EGIT_REPO_URI="git://git.videolan.org/x264.git"
EGIT_PATCHES=(${FILESDIR}/${PN}-*.diff)

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="X mp4 sdl threads static debug pic ffmpeg"

RDEPEND="
	mp4? ( media-video/gpac )
	X? ( x11-libs/libX11 )
	sdl? ( media-libs/libsdl )
	ffmpeg? ( media-video/ffmpeg )
"
DEPEND="
	${RDEPEND}
	>=dev-lang/yasm-0.6.2
"

src_compile() {
	econf\
		--disable-avs-input\
		--enable-pic\
		$(use_enable !static shared)\
		$(use_enable threads pthread)\
		$(use_enable mp4 mp4-output)\
		$(use_enable X visualize)\
		$(use_enable debug)\
		$(use_enable pic)\
		$(use_enable !pic asm)\
		$(use_enable ffmpeg lavf-input )\
		--extra-cflags="${CFLAGS}"\
		--extra-ldflags="$LDFLAGS"\
		--extra-asflags="${ASFLAGS}"\
		${myconf} || die
	touch .depend

	emake CC="$(tc-getCC)" || die

	if use sdl; then
		local _cmd="$(tc-getCC) $CFLAGS $LDFLAGS -o xyuv tools/xyuv.c
			$(sdl-config --libs)"
		echo ${_cmd}
		eval ${_cmd}
	fi

	use X && echo "Requires: x11" >> x264.pc
}

src_test() {
	emake checkasm || die
	./checkasm || die
}

src_install() {
	emake DESTDIR=${D} install || die
	use sdl && dobin xyuv
	dodoc AUTHORS doc/*.txt tools/*.pl
}
