# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

S="${WORKDIR}"
inherit font unpacker

DESCRIPTION="A realist sans-serif typeface based on ATF 1908 News Gothic"
HOMEPAGE="http://openfontlibrary.org/en/font/news-cycle"
SRC_URI="
http://openfontlibrary.org/assets/downloads/${PN}/d16d9c8311c84dd3d03841e9606a0b0d/${PN}.zip
-> ${P}.zip
"
RESTRICT="primaryuri"

LICENSE="OFL-1.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="fontforge"

DEPEND="
	$(unpacker_src_uri_depends)
"
RDEPEND=""

FONT_SUFFIX="ttf"
