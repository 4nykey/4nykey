# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit font

DESCRIPTION="Unicode 4.0 compliant TrueType font"
HOMEPAGE="http://titus.uni-frankfurt.de/unicode/unitest2.htm#TITUUT"
SRC_URI="TITUSCBZ.TTF"
RESTRICT="fetch"
S="${WORKDIR}"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~x86"

FONT_SUFFIX="TTF"
FONT_S="${S}"

pkg_nofetch() {
	einfo "Please download the font from:"
	einfo "http://titus.fkidg1.uni-frankfurt.de/unicode/tituut.asp"
	einfo "unzip it and move ${A} to ${DISTDIR}"
}

src_unpack() {
	cp ${DISTDIR}/${A} ${S}
}
