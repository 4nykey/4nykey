# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit font

DESCRIPTION="Unicode 4.0 compliant TrueType font"
HOMEPAGE="http://titus.fkidg1.uni-frankfurt.de/index.html"
SRC_URI="tu22134.zip"
RESTRICT="fetch"
S="${WORKDIR}"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND="app-arch/unzip"
RDEPEND=""

DOCS="Diauni.txt"
FONT_SUFFIX="TTF"
FONT_S="${S}"

pkg_nofetch() {
	einfo "Please download ${A} from:"
	einfo http://foo.bar
	einfo "and move it to ${DISTDIR}"
}
