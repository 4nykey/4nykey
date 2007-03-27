# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit font

DESCRIPTION="Free unicode TrueType fonts by George Williams"
HOMEPAGE="http://bibliofile.mc.duke.edu/gww/fonts"
SRC_URI="mirror://debian/pool/main/g/${PN}/${PN}_${PV}.orig.tar.gz"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND="app-arch/unzip"
RDEPEND=""

DOCS="COPYING README"
FONT_SUFFIX="ttf TTF"
FONT_S="${S}"

src_unpack() {
	unpack ${A}
	cd ${S}
	for x in *.zip; do unzip -qo $x; done
	gzip -d Caliban.ttf.gz
}
