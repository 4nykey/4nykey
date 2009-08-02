# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="OpenType to BDF Converter"
HOMEPAGE="http://www.math.nmsu.edu/~mleisher/Software/otf2bdf/"
SRC_URI="http://www.math.nmsu.edu/~mleisher/Software/${PN}/${P}.tbz2"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	media-libs/freetype:2
"
RDEPEND="
	${DEPEND}
"

src_install() {
	dobin otf2bdf
	mv otf2bdf.man otf2bdf.1
	doman otf2bdf.1
	dodoc README
}
