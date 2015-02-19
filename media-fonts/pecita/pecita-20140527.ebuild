# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

S="${WORKDIR}"
inherit font unpacker

DESCRIPTION="Pecita is a typeface that mimics handwriting"
HOMEPAGE="http://pecita.eu"
SRC_URI="
http://openfontlibrary.org/assets/downloads/${PN}/e34a8d3378efbb4d9f0be1ee9e3362f6/${PN}.zip
-> ${P}.zip
"
RESTRICT="primaryuri"

LICENSE="OFL-1.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

FONT_SUFFIX="otf"
