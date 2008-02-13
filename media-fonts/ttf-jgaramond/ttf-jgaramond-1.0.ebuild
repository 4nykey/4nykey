# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit font

DESCRIPTION="TrueType font similar to Garamond with additional Unicode chars"
HOMEPAGE="http://www.janthor.com/jGaramond"
SRC_URI="http://www.janthor.com/jGaramond/jGara.zip"
S="${WORKDIR}"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND="app-arch/unzip"
RDEPEND=""

DOCS="jGaramd2.txt"
FONT_SUFFIX="ttf"
FONT_S="${S}"
