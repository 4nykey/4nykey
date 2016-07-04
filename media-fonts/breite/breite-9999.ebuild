# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=6

inherit font
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/metapolator/Breite"
else
	inherit vcs-snapshot
	MY_PV="93e02d7"
	SRC_URI="
		https://codeload.github.com/metapolator/${PN}/tar.gz/${MY_PV}
		-> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="Breite Grotesk is a Multi-language Font Family"
HOMEPAGE="https://github.com/metapolator/Breite"

LICENSE="OFL-1.1"
SLOT="0"
IUSE=""

RDEPEND=""
DEPEND="
	${RDEPEND}
	media-gfx/fontforge
	media-gfx/ttfautohint
"
FONT_SUFFIX="otf"
DOCS=( README.md )

src_prepare() {
	default
	local _o
	cd Output
	for _o in *.otf; do mv "${_o}" BreiteGrotesk-"${_o// /}"; done
	mv *.otf "${FONT_S}"
}
