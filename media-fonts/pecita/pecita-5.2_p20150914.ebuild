# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

FONT_TYPES="otf"
S="${WORKDIR}"
inherit font-r1 unpacker

DESCRIPTION="A typeface that mimics handwriting"
HOMEPAGE="http://pecita.eu"
SRC_URI="c7230bc2a72ad2313a2e2e515b0fd16a"
SRC_URI="
http://openfontlibrary.org/assets/downloads/${PN}/${SRC_URI}/${PN}.zip
-> ${P}.zip
"
RESTRICT="primaryuri"

LICENSE="OFL-1.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="$(unpacker_src_uri_depends)"
RDEPEND="${DEPEND}"

DOCS="Pecita.txt"
