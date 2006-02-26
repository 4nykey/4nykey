# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit toolchain-funcs

DESCRIPTION="MP3val is a tool for MPEG audio files validation"
HOMEPAGE="http://mp3val.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}-src.tar.bz2"
S="${WORKDIR}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND="virtual/libc"
RDEPEND="${DEPEND}"

src_compile() {
	echo "$(tc-getCXX) $CFLAGS $LDFLAGS -o mp3val *.cpp"
	$(tc-getCXX) $CFLAGS $LDFLAGS -o mp3val *.cpp || die
}

src_install() {
	dobin mp3val
	dohtml manual.html
}

