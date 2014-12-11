# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

if [[ ${PV} == *9999* ]]; then
	inherit git-r3 font
	EGIT_REPO_URI="https://bitbucket.org/georgd/${PN}.git"
	DEPEND="
		media-gfx/fontforge[python]
		media-gfx/ttfautohint
	"
else
	MY_P="${PN/eb-g/EBG}-${PV}"
	S="${WORKDIR}/${MY_P}"
	inherit unpacker font
	SRC_URI="https://bitbucket.org/georgd/${PN}/downloads/${MY_P}.zip -> ${P}.zip"
	RESTRICT="primaryuri"
	DEPEND="$(unpacker_src_uri_depends)"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="This project aims at providing a free version of the Garamond typeface"
HOMEPAGE="http://www.georgduffner.at/ebgaramond"

LICENSE="OFL-1.1"
SLOT="0"

RDEPEND=""

FONT_SUFFIX="otf ttf"
DOCS="Changes specimen/Specimen.pdf"

src_compile() {
	if [[ ${PV} == *9999* ]]; then
		emake otf ttf
		mv build/*.[ot]tf .
	else
		mv otf/*.otf ttf/*.ttf .
	fi
}
