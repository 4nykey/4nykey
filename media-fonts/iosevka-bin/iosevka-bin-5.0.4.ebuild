# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_FONT_TYPES=( ttc +ttf )
MY_FONT_VARIANTS=(
	aile
	curly
	+default
	etoile
	slab
	fixed
	ss01
	ss02
	ss03
	ss04
	ss05
	ss06
	ss07
	ss08
	ss09
	ss10
	ss11
	ss12
	ss13
	ss14
	ss15
	ss16
	ss17
	term
)
MY_PN="${PN%-*}"
FONT_PN="${MY_PN}"
MY_PV=$(ver_rs 3 '-' 4 '.')
SRC_URI="https://github.com/be5invis/${MY_PN^}/releases/download/v${MY_PV}/"
SRC_URI="
font_types_ttf? (
	autohint? (
		font_variants_default? ( ${SRC_URI}ttf-${MY_PN}-${MY_PV}.zip )
		font_variants_fixed? (
			${SRC_URI}ttf-${MY_PN}-fixed-${MY_PV}.zip
			font_variants_ss01? ( ${SRC_URI}ttf-${MY_PN}-fixed-ss01-${MY_PV}.zip )
			font_variants_ss02? ( ${SRC_URI}ttf-${MY_PN}-fixed-ss02-${MY_PV}.zip )
			font_variants_ss03? ( ${SRC_URI}ttf-${MY_PN}-fixed-ss03-${MY_PV}.zip )
			font_variants_ss04? ( ${SRC_URI}ttf-${MY_PN}-fixed-ss04-${MY_PV}.zip )
			font_variants_ss05? ( ${SRC_URI}ttf-${MY_PN}-fixed-ss05-${MY_PV}.zip )
			font_variants_ss06? ( ${SRC_URI}ttf-${MY_PN}-fixed-ss06-${MY_PV}.zip )
			font_variants_ss07? ( ${SRC_URI}ttf-${MY_PN}-fixed-ss07-${MY_PV}.zip )
			font_variants_ss08? ( ${SRC_URI}ttf-${MY_PN}-fixed-ss08-${MY_PV}.zip )
			font_variants_ss09? ( ${SRC_URI}ttf-${MY_PN}-fixed-ss09-${MY_PV}.zip )
			font_variants_ss10? ( ${SRC_URI}ttf-${MY_PN}-fixed-ss10-${MY_PV}.zip )
			font_variants_ss11? ( ${SRC_URI}ttf-${MY_PN}-fixed-ss11-${MY_PV}.zip )
			font_variants_ss12? ( ${SRC_URI}ttf-${MY_PN}-fixed-ss12-${MY_PV}.zip )
			font_variants_ss13? ( ${SRC_URI}ttf-${MY_PN}-fixed-ss13-${MY_PV}.zip )
			font_variants_ss14? ( ${SRC_URI}ttf-${MY_PN}-fixed-ss14-${MY_PV}.zip )
			font_variants_ss15? ( ${SRC_URI}ttf-${MY_PN}-fixed-ss15-${MY_PV}.zip )
			font_variants_ss16? ( ${SRC_URI}ttf-${MY_PN}-fixed-ss16-${MY_PV}.zip )
			font_variants_ss17? ( ${SRC_URI}ttf-${MY_PN}-fixed-ss17-${MY_PV}.zip )
		)
		font_variants_term? (
			${SRC_URI}ttf-${MY_PN}-term-${MY_PV}.zip
			font_variants_ss01? ( ${SRC_URI}ttf-${MY_PN}-term-ss01-${MY_PV}.zip )
			font_variants_ss02? ( ${SRC_URI}ttf-${MY_PN}-term-ss02-${MY_PV}.zip )
			font_variants_ss03? ( ${SRC_URI}ttf-${MY_PN}-term-ss03-${MY_PV}.zip )
			font_variants_ss04? ( ${SRC_URI}ttf-${MY_PN}-term-ss04-${MY_PV}.zip )
			font_variants_ss05? ( ${SRC_URI}ttf-${MY_PN}-term-ss05-${MY_PV}.zip )
			font_variants_ss06? ( ${SRC_URI}ttf-${MY_PN}-term-ss06-${MY_PV}.zip )
			font_variants_ss07? ( ${SRC_URI}ttf-${MY_PN}-term-ss07-${MY_PV}.zip )
			font_variants_ss08? ( ${SRC_URI}ttf-${MY_PN}-term-ss08-${MY_PV}.zip )
			font_variants_ss09? ( ${SRC_URI}ttf-${MY_PN}-term-ss09-${MY_PV}.zip )
			font_variants_ss10? ( ${SRC_URI}ttf-${MY_PN}-term-ss10-${MY_PV}.zip )
			font_variants_ss11? ( ${SRC_URI}ttf-${MY_PN}-term-ss11-${MY_PV}.zip )
			font_variants_ss12? ( ${SRC_URI}ttf-${MY_PN}-term-ss12-${MY_PV}.zip )
			font_variants_ss13? ( ${SRC_URI}ttf-${MY_PN}-term-ss13-${MY_PV}.zip )
			font_variants_ss14? ( ${SRC_URI}ttf-${MY_PN}-term-ss14-${MY_PV}.zip )
			font_variants_ss15? ( ${SRC_URI}ttf-${MY_PN}-term-ss15-${MY_PV}.zip )
			font_variants_ss16? ( ${SRC_URI}ttf-${MY_PN}-term-ss16-${MY_PV}.zip )
			font_variants_ss17? ( ${SRC_URI}ttf-${MY_PN}-term-ss17-${MY_PV}.zip )
		)
		font_variants_slab? (
			font_variants_default? ( ${SRC_URI}ttf-${MY_PN}-slab-${MY_PV}.zip )
			font_variants_fixed? ( ${SRC_URI}ttf-${MY_PN}-fixed-slab-${MY_PV}.zip )
			font_variants_term? ( ${SRC_URI}ttf-${MY_PN}-term-slab-${MY_PV}.zip )
		)
		font_variants_curly? (
			font_variants_default? ( ${SRC_URI}ttf-${MY_PN}-curly-${MY_PV}.zip )
			font_variants_fixed? ( ${SRC_URI}ttf-${MY_PN}-fixed-curly-${MY_PV}.zip )
			font_variants_term? ( ${SRC_URI}ttf-${MY_PN}-term-curly-${MY_PV}.zip )
			font_variants_slab? (
				${SRC_URI}ttf-${MY_PN}-curly-slab-${MY_PV}.zip
				font_variants_fixed? ( ${SRC_URI}ttf-${MY_PN}-fixed-curly-slab-${MY_PV}.zip )
				font_variants_term? ( ${SRC_URI}ttf-${MY_PN}-term-curly-slab-${MY_PV}.zip )
			)
		)
		font_variants_ss01? ( ${SRC_URI}ttf-${MY_PN}-ss01-${MY_PV}.zip )
		font_variants_ss02? ( ${SRC_URI}ttf-${MY_PN}-ss02-${MY_PV}.zip )
		font_variants_ss03? ( ${SRC_URI}ttf-${MY_PN}-ss03-${MY_PV}.zip )
		font_variants_ss04? ( ${SRC_URI}ttf-${MY_PN}-ss04-${MY_PV}.zip )
		font_variants_ss05? ( ${SRC_URI}ttf-${MY_PN}-ss05-${MY_PV}.zip )
		font_variants_ss06? ( ${SRC_URI}ttf-${MY_PN}-ss06-${MY_PV}.zip )
		font_variants_ss07? ( ${SRC_URI}ttf-${MY_PN}-ss07-${MY_PV}.zip )
		font_variants_ss08? ( ${SRC_URI}ttf-${MY_PN}-ss08-${MY_PV}.zip )
		font_variants_ss09? ( ${SRC_URI}ttf-${MY_PN}-ss09-${MY_PV}.zip )
		font_variants_ss10? ( ${SRC_URI}ttf-${MY_PN}-ss10-${MY_PV}.zip )
		font_variants_ss11? ( ${SRC_URI}ttf-${MY_PN}-ss11-${MY_PV}.zip )
		font_variants_ss12? ( ${SRC_URI}ttf-${MY_PN}-ss12-${MY_PV}.zip )
		font_variants_ss13? ( ${SRC_URI}ttf-${MY_PN}-ss13-${MY_PV}.zip )
		font_variants_ss14? ( ${SRC_URI}ttf-${MY_PN}-ss14-${MY_PV}.zip )
		font_variants_aile? ( ${SRC_URI}ttf-${MY_PN}-aile-${MY_PV}.zip )
		font_variants_etoile? ( ${SRC_URI}ttf-${MY_PN}-etoile-${MY_PV}.zip )
	)
	!autohint? (
		font_variants_default? ( ${SRC_URI}ttf-unhinted-${MY_PN}-${MY_PV}.zip )
		font_variants_fixed? (
			${SRC_URI}ttf-unhinted-${MY_PN}-fixed-${MY_PV}.zip
			font_variants_ss01? ( ${SRC_URI}ttf-unhinted-${MY_PN}-fixed-ss01-${MY_PV}.zip )
			font_variants_ss02? ( ${SRC_URI}ttf-unhinted-${MY_PN}-fixed-ss02-${MY_PV}.zip )
			font_variants_ss03? ( ${SRC_URI}ttf-unhinted-${MY_PN}-fixed-ss03-${MY_PV}.zip )
			font_variants_ss04? ( ${SRC_URI}ttf-unhinted-${MY_PN}-fixed-ss04-${MY_PV}.zip )
			font_variants_ss05? ( ${SRC_URI}ttf-unhinted-${MY_PN}-fixed-ss05-${MY_PV}.zip )
			font_variants_ss06? ( ${SRC_URI}ttf-unhinted-${MY_PN}-fixed-ss06-${MY_PV}.zip )
			font_variants_ss07? ( ${SRC_URI}ttf-unhinted-${MY_PN}-fixed-ss07-${MY_PV}.zip )
			font_variants_ss08? ( ${SRC_URI}ttf-unhinted-${MY_PN}-fixed-ss08-${MY_PV}.zip )
			font_variants_ss09? ( ${SRC_URI}ttf-unhinted-${MY_PN}-fixed-ss09-${MY_PV}.zip )
			font_variants_ss10? ( ${SRC_URI}ttf-unhinted-${MY_PN}-fixed-ss10-${MY_PV}.zip )
			font_variants_ss11? ( ${SRC_URI}ttf-unhinted-${MY_PN}-fixed-ss11-${MY_PV}.zip )
			font_variants_ss12? ( ${SRC_URI}ttf-unhinted-${MY_PN}-fixed-ss12-${MY_PV}.zip )
			font_variants_ss13? ( ${SRC_URI}ttf-unhinted-${MY_PN}-fixed-ss13-${MY_PV}.zip )
			font_variants_ss14? ( ${SRC_URI}ttf-unhinted-${MY_PN}-fixed-ss14-${MY_PV}.zip )
			font_variants_ss15? ( ${SRC_URI}ttf-unhinted-${MY_PN}-fixed-ss15-${MY_PV}.zip )
			font_variants_ss16? ( ${SRC_URI}ttf-unhinted-${MY_PN}-fixed-ss16-${MY_PV}.zip )
			font_variants_ss17? ( ${SRC_URI}ttf-unhinted-${MY_PN}-fixed-ss17-${MY_PV}.zip )
		)
		font_variants_term? (
			${SRC_URI}ttf-unhinted-${MY_PN}-term-${MY_PV}.zip
			font_variants_ss01? ( ${SRC_URI}ttf-unhinted-${MY_PN}-term-ss01-${MY_PV}.zip )
			font_variants_ss02? ( ${SRC_URI}ttf-unhinted-${MY_PN}-term-ss02-${MY_PV}.zip )
			font_variants_ss03? ( ${SRC_URI}ttf-unhinted-${MY_PN}-term-ss03-${MY_PV}.zip )
			font_variants_ss04? ( ${SRC_URI}ttf-unhinted-${MY_PN}-term-ss04-${MY_PV}.zip )
			font_variants_ss05? ( ${SRC_URI}ttf-unhinted-${MY_PN}-term-ss05-${MY_PV}.zip )
			font_variants_ss06? ( ${SRC_URI}ttf-unhinted-${MY_PN}-term-ss06-${MY_PV}.zip )
			font_variants_ss07? ( ${SRC_URI}ttf-unhinted-${MY_PN}-term-ss07-${MY_PV}.zip )
			font_variants_ss08? ( ${SRC_URI}ttf-unhinted-${MY_PN}-term-ss08-${MY_PV}.zip )
			font_variants_ss09? ( ${SRC_URI}ttf-unhinted-${MY_PN}-term-ss09-${MY_PV}.zip )
			font_variants_ss10? ( ${SRC_URI}ttf-unhinted-${MY_PN}-term-ss10-${MY_PV}.zip )
			font_variants_ss11? ( ${SRC_URI}ttf-unhinted-${MY_PN}-term-ss11-${MY_PV}.zip )
			font_variants_ss12? ( ${SRC_URI}ttf-unhinted-${MY_PN}-term-ss12-${MY_PV}.zip )
			font_variants_ss13? ( ${SRC_URI}ttf-unhinted-${MY_PN}-term-ss13-${MY_PV}.zip )
			font_variants_ss14? ( ${SRC_URI}ttf-unhinted-${MY_PN}-term-ss14-${MY_PV}.zip )
			font_variants_ss15? ( ${SRC_URI}ttf-unhinted-${MY_PN}-term-ss15-${MY_PV}.zip )
			font_variants_ss16? ( ${SRC_URI}ttf-unhinted-${MY_PN}-term-ss16-${MY_PV}.zip )
			font_variants_ss17? ( ${SRC_URI}ttf-unhinted-${MY_PN}-term-ss17-${MY_PV}.zip )
		)
		font_variants_slab? (
			font_variants_default? ( ${SRC_URI}ttf-unhinted-${MY_PN}-slab-${MY_PV}.zip )
			font_variants_fixed? ( ${SRC_URI}ttf-unhinted-${MY_PN}-fixed-slab-${MY_PV}.zip )
			font_variants_term? ( ${SRC_URI}ttf-unhinted-${MY_PN}-term-slab-${MY_PV}.zip )
		)
		font_variants_curly? (
			font_variants_default? ( ${SRC_URI}ttf-unhinted-${MY_PN}-curly-${MY_PV}.zip )
			font_variants_fixed? ( ${SRC_URI}ttf-unhinted-${MY_PN}-fixed-curly-${MY_PV}.zip )
			font_variants_term? ( ${SRC_URI}ttf-unhinted-${MY_PN}-term-curly-${MY_PV}.zip )
			font_variants_slab? (
				${SRC_URI}ttf-unhinted-${MY_PN}-curly-slab-${MY_PV}.zip
				font_variants_fixed? ( ${SRC_URI}ttf-unhinted-${MY_PN}-fixed-curly-slab-${MY_PV}.zip )
				font_variants_term? ( ${SRC_URI}ttf-unhinted-${MY_PN}-term-curly-slab-${MY_PV}.zip )
			)
		)
		font_variants_ss01? ( ${SRC_URI}ttf-unhinted-${MY_PN}-ss01-${MY_PV}.zip )
		font_variants_ss02? ( ${SRC_URI}ttf-unhinted-${MY_PN}-ss02-${MY_PV}.zip )
		font_variants_ss03? ( ${SRC_URI}ttf-unhinted-${MY_PN}-ss03-${MY_PV}.zip )
		font_variants_ss04? ( ${SRC_URI}ttf-unhinted-${MY_PN}-ss04-${MY_PV}.zip )
		font_variants_ss05? ( ${SRC_URI}ttf-unhinted-${MY_PN}-ss05-${MY_PV}.zip )
		font_variants_ss06? ( ${SRC_URI}ttf-unhinted-${MY_PN}-ss06-${MY_PV}.zip )
		font_variants_ss07? ( ${SRC_URI}ttf-unhinted-${MY_PN}-ss07-${MY_PV}.zip )
		font_variants_ss08? ( ${SRC_URI}ttf-unhinted-${MY_PN}-ss08-${MY_PV}.zip )
		font_variants_ss09? ( ${SRC_URI}ttf-unhinted-${MY_PN}-ss09-${MY_PV}.zip )
		font_variants_ss10? ( ${SRC_URI}ttf-unhinted-${MY_PN}-ss10-${MY_PV}.zip )
		font_variants_ss11? ( ${SRC_URI}ttf-unhinted-${MY_PN}-ss11-${MY_PV}.zip )
		font_variants_ss12? ( ${SRC_URI}ttf-unhinted-${MY_PN}-ss12-${MY_PV}.zip )
		font_variants_ss13? ( ${SRC_URI}ttf-unhinted-${MY_PN}-ss13-${MY_PV}.zip )
		font_variants_ss14? ( ${SRC_URI}ttf-unhinted-${MY_PN}-ss14-${MY_PV}.zip )
		font_variants_ss15? ( ${SRC_URI}ttf-unhinted-${MY_PN}-ss15-${MY_PV}.zip )
		font_variants_ss16? ( ${SRC_URI}ttf-unhinted-${MY_PN}-ss16-${MY_PV}.zip )
		font_variants_ss17? ( ${SRC_URI}ttf-unhinted-${MY_PN}-ss17-${MY_PV}.zip )
		font_variants_aile? ( ${SRC_URI}ttf-unhinted-${MY_PN}-aile-${MY_PV}.zip )
		font_variants_etoile? ( ${SRC_URI}ttf-unhinted-${MY_PN}-etoile-${MY_PV}.zip )
	)
)
font_types_ttc? (
		font_variants_default? ( ${SRC_URI}super-ttc-${MY_PN}-${MY_PV}.zip )
		font_variants_curly? ( ${SRC_URI}super-ttc-${MY_PN}-curly-${MY_PV}.zip )
		font_variants_slab? (
			${SRC_URI}super-ttc-${MY_PN}-slab-${MY_PV}.zip
			font_variants_curly? ( ${SRC_URI}super-ttc-${MY_PN}-curly-slab-${MY_PV}.zip )
			)
		font_variants_aile? ( ${SRC_URI}super-ttc-${MY_PN}-aile-${MY_PV}.zip )
		font_variants_etoile? ( ${SRC_URI}super-ttc-${MY_PN}-etoile-${MY_PV}.zip )
		font_variants_ss01? ( ${SRC_URI}super-ttc-${MY_PN}-ss01-${MY_PV}.zip )
		font_variants_ss02? ( ${SRC_URI}super-ttc-${MY_PN}-ss02-${MY_PV}.zip )
		font_variants_ss03? ( ${SRC_URI}super-ttc-${MY_PN}-ss03-${MY_PV}.zip )
		font_variants_ss04? ( ${SRC_URI}super-ttc-${MY_PN}-ss04-${MY_PV}.zip )
		font_variants_ss05? ( ${SRC_URI}super-ttc-${MY_PN}-ss05-${MY_PV}.zip )
		font_variants_ss06? ( ${SRC_URI}super-ttc-${MY_PN}-ss06-${MY_PV}.zip )
		font_variants_ss07? ( ${SRC_URI}super-ttc-${MY_PN}-ss07-${MY_PV}.zip )
		font_variants_ss08? ( ${SRC_URI}super-ttc-${MY_PN}-ss08-${MY_PV}.zip )
		font_variants_ss09? ( ${SRC_URI}super-ttc-${MY_PN}-ss09-${MY_PV}.zip )
		font_variants_ss10? ( ${SRC_URI}super-ttc-${MY_PN}-ss10-${MY_PV}.zip )
		font_variants_ss11? ( ${SRC_URI}super-ttc-${MY_PN}-ss11-${MY_PV}.zip )
		font_variants_ss12? ( ${SRC_URI}super-ttc-${MY_PN}-ss12-${MY_PV}.zip )
		font_variants_ss13? ( ${SRC_URI}super-ttc-${MY_PN}-ss13-${MY_PV}.zip )
		font_variants_ss14? ( ${SRC_URI}super-ttc-${MY_PN}-ss14-${MY_PV}.zip )
		font_variants_ss15? ( ${SRC_URI}super-ttc-${MY_PN}-ss15-${MY_PV}.zip )
		font_variants_ss16? ( ${SRC_URI}super-ttc-${MY_PN}-ss16-${MY_PV}.zip )
		font_variants_ss17? ( ${SRC_URI}super-ttc-${MY_PN}-ss17-${MY_PV}.zip )
)
"
RESTRICT="primaryuri"
BDEPEND="app-arch/unzip"
KEYWORDS="~amd64 ~x86"
S="${WORKDIR}"
inherit font-r1

DESCRIPTION="Spatial efficient monospace font family for programming"
HOMEPAGE="https://be5invis.github.io/Iosevka"

LICENSE="OFL-1.1"
SLOT="0"
IUSE="+autohint"
REQUIRED_USE="
?? ( ${MY_FONT_TYPES[@]/#+/} )
|| ( ${MY_FONT_VARIANTS[@]/#+/} )
"
RDEPEND="
	!media-fonts/iosevka
"
