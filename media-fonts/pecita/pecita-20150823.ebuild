# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

S="${WORKDIR}"
inherit font unpacker

DESCRIPTION="Pecita is a typeface that mimics handwriting"
HOMEPAGE="http://pecita.eu"
MY_MD5="2ccbb215bd63c7e377bcc0762159f3db"
SRC_URI="
http://openfontlibrary.org/assets/downloads/${PN}/${MY_MD5}/${PN}.zip
-> ${P}.zip
"
RESTRICT="primaryuri"

LICENSE="OFL-1.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="$(unpacker_src_uri_depends)"
RDEPEND="${DEPEND}"

FONT_SUFFIX="otf"
DOCS="Pecita.txt"
