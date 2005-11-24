# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

inherit subversion

DESCRIPTION="Tarkin is a experimental 3d-integer-wavelet-video compression codec."
HOMEPAGE="http://www.xiph.org/"
ESVN_REPO_URI="http://svn.xiph.org/trunk/w3d"

LICENSE="xiph"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND=">=media-libs/libogg-1.1.0
	media-libs/sdl"

S=${WORKDIR}/${PN}

src_compile() {
	epatch ${FILESDIR}/Makefile.patch
	make || die
	make -C tools || die
}

src_install() {
	dolib.a libtarkin.a
	dobin tarkin_{enc,dec,sdl_player} tools/{yuv2ppm,pnmdiff}
	dodoc README TODO WHAT_THE_HECK_IS_THIS_CODE_DOING
}
