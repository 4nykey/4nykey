# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools
DESCRIPTION="OpenType to BDF Converter"
HOMEPAGE="http://sofia.nmsu.edu/~mleisher/Software/otf2bdf/"
SRC_URI="http://sofia.nmsu.edu/~mleisher/Software/${PN}/${P}.tbz2"

LICENSE="MIT"
SLOT=0
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	media-libs/freetype:2
"
RDEPEND="
	${DEPEND}
"
PATCHES="${FILESDIR}/${PN}-freetype.diff"

src_prepare() {
	default
	mv -f configure.{in,ac}
	eautoreconf
}

src_install() {
	dobin otf2bdf
	newman otf2bdf.man otf2bdf.1
	dodoc README
}
