# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=6

if [[ ${PV} == *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/impallari/Raleway.git"
else
	inherit vcs-snapshot
	MY_PV="010399c"
	SRC_URI="
		mirror://githubcl/impallari/Raleway/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi
inherit font

DESCRIPTION="Raleway is an elegant sans-serif typeface"
HOMEPAGE="http://www.impallari.com/projects/overview/matt-mcinerneys-raleway-family"

LICENSE="OFL-1.1"
SLOT="0"
IUSE="+binary"

DEPEND="
	!binary? ( dev-python/fontmake )
"
RDEPEND=""

FONT_SUFFIX="otf"
DOCS="CONTRIBUTORS.txt FONTLOG.txt README.md"

src_prepare() {
	default
	use binary && mv "${S}/fonts/OTF v4.006 Glyphs"/*.otf "${FONT_S}"
}

src_compile() {
	use binary && return

	local _g
	for _g in "${S}"/src/*.glyphs; do
		fontmake \
			--output otf \
			--interpolate \
			--glyphs-path "${_g}"
	done
	mv "${S}"/instance_otf/*.otf "${FONT_S}"
}
