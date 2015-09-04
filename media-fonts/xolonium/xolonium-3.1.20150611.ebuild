# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

S="${WORKDIR}/${PN}-fonts-${PV%.*}"
inherit font unpacker

DESCRIPTION="A futuristic font with focus on legibility"
HOMEPAGE="http://openfontlibrary.org/en/font/xolonium"
MY_MD5="d635151379b3d9b783678f1b0fb6a691"
SRC_URI="
http://openfontlibrary.org/assets/downloads/${PN}/${MY_MD5}/${PN}.zip
-> ${P}.zip
"
RESTRICT="primaryuri"

LICENSE="OFL-1.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	$(unpacker_src_uri_depends)
"
RDEPEND=""

FONT_SUFFIX="otf"
DOCS="FEATURES.txt"
