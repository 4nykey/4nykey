# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

FONT_SUFFIX=otf
inherit font-r1 unpacker

DESCRIPTION="A serif typeface predominantly based off Dwiggins Electra"
HOMEPAGE="https://fontlibrary.org/font/${PN}"
SRC_URI="
	mirror://fontlibrary/${PN}/669f3553a8addabe8c1cf08f25f594bd/${PN}.zip
	-> ${P}.zip
"
RESTRICT="primaryuri"

LICENSE="OFL-1.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="$(unpacker_src_uri_depends)"
S="${WORKDIR}/${PN^}"
DOCS="${PN^}-fl.txt"
