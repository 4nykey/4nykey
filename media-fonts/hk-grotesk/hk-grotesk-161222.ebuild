# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

FONT_TYPES="otf ttf"
inherit font-r1 unpacker

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

DEPEND="$(unpacker_src_uri_depends)"
S="${WORKDIR}"
FONT_S=( OTF TTF )
