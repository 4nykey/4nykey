# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

MY_FONT_TYPES=( otf +ttf )
inherit font-r1

DESCRIPTION="A sans serif typeface inspired from the classical grotesques"
HOMEPAGE="https://hanken.co/product/${PN}"
SRC_URI="
	mirror://fontlibrary/${PN}/f94e19ac1b199714e3794c5168b27546/${PN}.zip
	-> ${P}.zip
"
RESTRICT="primaryuri"

LICENSE="OFL-1.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="app-arch/unzip"
S="${WORKDIR}"
FONT_S=( OTF TTF )
