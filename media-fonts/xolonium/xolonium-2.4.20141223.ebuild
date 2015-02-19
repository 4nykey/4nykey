# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

S="${WORKDIR}/${PN}-fonts-${PV%.*}"
inherit font unpacker

DESCRIPTION="A futuristic font with focus on legibility"
HOMEPAGE="http://openfontlibrary.org/en/font/xolonium"
SRC_URI="
http://openfontlibrary.org/assets/downloads/${PN}/6f2ce8e5d31d2c8e9a05d7f187451b81/${PN}.zip
-> ${P}.zip
"
RESTRICT="primaryuri"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="fontforge"

DEPEND="
	fontforge? ( media-gfx/fontforge )
	$(unpacker_src_uri_depends)
"
RDEPEND=""

FONT_SUFFIX="otf"
DOCS="CHARLIST CREDITS"

src_prepare() {
	if use fontforge; then
		mv sourcefiles/*.* .
	else
		mv fonts/*.otf .
	fi
}

src_compile() {
	if use fontforge; then
		fontforge compile.ff || die "compile failed"
	fi
}
