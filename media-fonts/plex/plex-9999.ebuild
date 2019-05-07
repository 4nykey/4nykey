# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

MY_FONT_TYPES=( otf +ttf )
FONT_S=(
	Arabic
	Devanagari
	Mono
	Sans
	Sans-Condensed
	Snas-Hebrew
	Serif
	Thai
	Thai-Looped
)
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/IBM/${PN}.git"
	FONT_S=(
		${FONT_S[@]/#/IBM-Plex-}
	)
	FONT_S=(
		${FONT_S[@]/%//fonts/complete/otf}
		${FONT_S[@]/%//fonts/complete/ttf}
	)
	DOCS=( {CHANGELOG,README}.md )
else
	SRC_URI="
		font_types_otf? (
			https://github.com/IBM/${PN}/releases/download/v${PV}/OpenType.zip
			-> ${P}-otf.zip
		)
		font_types_ttf? (
			https://github.com/IBM/${PN}/releases/download/v${PV}/TrueType.zip
		-> ${P}-ttf.zip
		)
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}"
	FONT_S=(
		${FONT_S[@]/#/OpenType/IBM-Plex-}
		${FONT_S[@]/#/TrueType/IBM-Plex-}
	)
	DEPEND="app-arch/unzip"
fi
inherit font-r1

DESCRIPTION="IBM's typeface"
HOMEPAGE="https://www.ibm.com/${PN}"

LICENSE="OFL-1.1"
SLOT="0"
