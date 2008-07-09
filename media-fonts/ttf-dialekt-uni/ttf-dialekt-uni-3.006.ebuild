# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit font

DESCRIPTION="Dialekt Unicode Font"
HOMEPAGE="http://www.thesauruslex.com/typo/engdial.htm"
SRC_URI="http://www.thesauruslex.com/typo/fonter/diauni.zip"
S="${WORKDIR}"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND="app-arch/unzip"
RDEPEND=""

DOCS="Diauni.txt"
FONT_SUFFIX="ttf"
FONT_S="${S}"
