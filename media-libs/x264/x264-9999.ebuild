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
IUSE="X mp4 sdl threads static debug"

RDEPEND="
	mp4? ( media-video/gpac )
	X? ( x11-libs/libX11 )
	sdl? ( media-libs/libsdl )
"
DEPEND="
	${RDEPEND}
	>=dev-lang/yasm-0.6.2
"

src_compile() {
	local myconf
	use X && myconf="--enable-visualize"
	use debug && myconf="${myconf} --enable-debug"

	GIT_DIR="${EGIT_STORE_DIR}/${EGIT_PROJECT}" \
	./configure\
		--prefix=/usr \
		--disable-avis-input \
		--enable-pic \
		$(use_enable !static shared) \
		$(use_enable threads pthread) \
		$(use_enable mp4 mp4-output)\
		--extra-cflags="${CFLAGS}"\
		--extra-ldflags="$LDFLAGS" \
		--extra-asflags="${ASFLAGS}" \
		${myconf} || die
	touch .depend

	emake CC="$(tc-getCC)" || die

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
	dobin x264
	use sdl && dobin xyuv
	dodoc AUTHORS doc/*.txt tools/*.{pl,sh}
}
