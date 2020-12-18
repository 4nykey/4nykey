# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_FONT_TYPES=( ttc +ttf )
MY_FONT_VARIANTS=(
	aile
	curly
	+default
	etoile
	slab
	sparkle
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
	term
)
if [[ ${PV} == *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/be5invis/${PN}.git"
	EGIT_BRANCH="dev"
	REQUIRED_USE="!binary"
else
	MY_PV=$(ver_rs 3 '-' 4 '.')
	SRC_URI="https://github.com/be5invis/${PN^}/releases/download/v${MY_PV}/"
	SRC_URI="
	binary? (
	font_types_ttf? (
		autohint? (
			font_variants_default? ( ${SRC_URI}ttf-${PN}-${MY_PV}.zip )
			font_variants_fixed? (
				${SRC_URI}ttf-${PN}-fixed-${MY_PV}.zip
				font_variants_ss01? ( ${SRC_URI}ttf-${PN}-fixed-ss01-${MY_PV}.zip )
				font_variants_ss02? ( ${SRC_URI}ttf-${PN}-fixed-ss02-${MY_PV}.zip )
				font_variants_ss03? ( ${SRC_URI}ttf-${PN}-fixed-ss03-${MY_PV}.zip )
				font_variants_ss04? ( ${SRC_URI}ttf-${PN}-fixed-ss04-${MY_PV}.zip )
				font_variants_ss05? ( ${SRC_URI}ttf-${PN}-fixed-ss05-${MY_PV}.zip )
				font_variants_ss06? ( ${SRC_URI}ttf-${PN}-fixed-ss06-${MY_PV}.zip )
				font_variants_ss07? ( ${SRC_URI}ttf-${PN}-fixed-ss07-${MY_PV}.zip )
				font_variants_ss08? ( ${SRC_URI}ttf-${PN}-fixed-ss08-${MY_PV}.zip )
				font_variants_ss09? ( ${SRC_URI}ttf-${PN}-fixed-ss09-${MY_PV}.zip )
				font_variants_ss10? ( ${SRC_URI}ttf-${PN}-fixed-ss10-${MY_PV}.zip )
				font_variants_ss11? ( ${SRC_URI}ttf-${PN}-fixed-ss11-${MY_PV}.zip )
				font_variants_ss12? ( ${SRC_URI}ttf-${PN}-fixed-ss12-${MY_PV}.zip )
				font_variants_ss13? ( ${SRC_URI}ttf-${PN}-fixed-ss13-${MY_PV}.zip )
				font_variants_ss14? ( ${SRC_URI}ttf-${PN}-fixed-ss14-${MY_PV}.zip )
			)
			font_variants_term? (
				${SRC_URI}ttf-${PN}-term-${MY_PV}.zip
				font_variants_ss01? ( ${SRC_URI}ttf-${PN}-term-ss01-${MY_PV}.zip )
				font_variants_ss02? ( ${SRC_URI}ttf-${PN}-term-ss02-${MY_PV}.zip )
				font_variants_ss03? ( ${SRC_URI}ttf-${PN}-term-ss03-${MY_PV}.zip )
				font_variants_ss04? ( ${SRC_URI}ttf-${PN}-term-ss04-${MY_PV}.zip )
				font_variants_ss05? ( ${SRC_URI}ttf-${PN}-term-ss05-${MY_PV}.zip )
				font_variants_ss06? ( ${SRC_URI}ttf-${PN}-term-ss06-${MY_PV}.zip )
				font_variants_ss07? ( ${SRC_URI}ttf-${PN}-term-ss07-${MY_PV}.zip )
				font_variants_ss08? ( ${SRC_URI}ttf-${PN}-term-ss08-${MY_PV}.zip )
				font_variants_ss09? ( ${SRC_URI}ttf-${PN}-term-ss09-${MY_PV}.zip )
				font_variants_ss10? ( ${SRC_URI}ttf-${PN}-term-ss10-${MY_PV}.zip )
				font_variants_ss11? ( ${SRC_URI}ttf-${PN}-term-ss11-${MY_PV}.zip )
				font_variants_ss12? ( ${SRC_URI}ttf-${PN}-term-ss12-${MY_PV}.zip )
				font_variants_ss13? ( ${SRC_URI}ttf-${PN}-term-ss13-${MY_PV}.zip )
				font_variants_ss14? ( ${SRC_URI}ttf-${PN}-term-ss14-${MY_PV}.zip )
			)
			font_variants_slab? (
				font_variants_default? ( ${SRC_URI}ttf-${PN}-slab-${MY_PV}.zip )
				font_variants_fixed? ( ${SRC_URI}ttf-${PN}-fixed-slab-${MY_PV}.zip )
				font_variants_term? ( ${SRC_URI}ttf-${PN}-term-slab-${MY_PV}.zip )
			)
			font_variants_curly? (
				font_variants_default? ( ${SRC_URI}ttf-${PN}-curly-${MY_PV}.zip )
				font_variants_fixed? ( ${SRC_URI}ttf-${PN}-fixed-curly-${MY_PV}.zip )
				font_variants_term? ( ${SRC_URI}ttf-${PN}-term-curly-${MY_PV}.zip )
				font_variants_slab? (
					${SRC_URI}ttf-${PN}-curly-slab-${MY_PV}.zip
					font_variants_fixed? ( ${SRC_URI}ttf-${PN}-fixed-curly-slab-${MY_PV}.zip )
					font_variants_term? ( ${SRC_URI}ttf-${PN}-term-curly-slab-${MY_PV}.zip )
				)
			)
			font_variants_ss01? ( ${SRC_URI}ttf-${PN}-ss01-${MY_PV}.zip )
			font_variants_ss02? ( ${SRC_URI}ttf-${PN}-ss02-${MY_PV}.zip )
			font_variants_ss03? ( ${SRC_URI}ttf-${PN}-ss03-${MY_PV}.zip )
			font_variants_ss04? ( ${SRC_URI}ttf-${PN}-ss04-${MY_PV}.zip )
			font_variants_ss05? ( ${SRC_URI}ttf-${PN}-ss05-${MY_PV}.zip )
			font_variants_ss06? ( ${SRC_URI}ttf-${PN}-ss06-${MY_PV}.zip )
			font_variants_ss07? ( ${SRC_URI}ttf-${PN}-ss07-${MY_PV}.zip )
			font_variants_ss08? ( ${SRC_URI}ttf-${PN}-ss08-${MY_PV}.zip )
			font_variants_ss09? ( ${SRC_URI}ttf-${PN}-ss09-${MY_PV}.zip )
			font_variants_ss10? ( ${SRC_URI}ttf-${PN}-ss10-${MY_PV}.zip )
			font_variants_ss11? ( ${SRC_URI}ttf-${PN}-ss11-${MY_PV}.zip )
			font_variants_ss12? ( ${SRC_URI}ttf-${PN}-ss12-${MY_PV}.zip )
			font_variants_ss13? ( ${SRC_URI}ttf-${PN}-ss13-${MY_PV}.zip )
			font_variants_ss14? ( ${SRC_URI}ttf-${PN}-ss14-${MY_PV}.zip )
			font_variants_aile? ( ${SRC_URI}ttf-${PN}-aile-${MY_PV}.zip )
			font_variants_etoile? ( ${SRC_URI}ttf-${PN}-etoile-${MY_PV}.zip )
			font_variants_sparkle? ( ${SRC_URI}ttf-${PN}-sparkle-${MY_PV}.zip )
		)
		!autohint? (
			font_variants_default? ( ${SRC_URI}ttf-unhinted-${PN}-${MY_PV}.zip )
			font_variants_fixed? (
				${SRC_URI}ttf-unhinted-${PN}-fixed-${MY_PV}.zip
				font_variants_ss01? ( ${SRC_URI}ttf-unhinted-${PN}-fixed-ss01-${MY_PV}.zip )
				font_variants_ss02? ( ${SRC_URI}ttf-unhinted-${PN}-fixed-ss02-${MY_PV}.zip )
				font_variants_ss03? ( ${SRC_URI}ttf-unhinted-${PN}-fixed-ss03-${MY_PV}.zip )
				font_variants_ss04? ( ${SRC_URI}ttf-unhinted-${PN}-fixed-ss04-${MY_PV}.zip )
				font_variants_ss05? ( ${SRC_URI}ttf-unhinted-${PN}-fixed-ss05-${MY_PV}.zip )
				font_variants_ss06? ( ${SRC_URI}ttf-unhinted-${PN}-fixed-ss06-${MY_PV}.zip )
				font_variants_ss07? ( ${SRC_URI}ttf-unhinted-${PN}-fixed-ss07-${MY_PV}.zip )
				font_variants_ss08? ( ${SRC_URI}ttf-unhinted-${PN}-fixed-ss08-${MY_PV}.zip )
				font_variants_ss09? ( ${SRC_URI}ttf-unhinted-${PN}-fixed-ss09-${MY_PV}.zip )
				font_variants_ss10? ( ${SRC_URI}ttf-unhinted-${PN}-fixed-ss10-${MY_PV}.zip )
				font_variants_ss11? ( ${SRC_URI}ttf-unhinted-${PN}-fixed-ss11-${MY_PV}.zip )
				font_variants_ss12? ( ${SRC_URI}ttf-unhinted-${PN}-fixed-ss12-${MY_PV}.zip )
				font_variants_ss13? ( ${SRC_URI}ttf-unhinted-${PN}-fixed-ss13-${MY_PV}.zip )
				font_variants_ss14? ( ${SRC_URI}ttf-unhinted-${PN}-fixed-ss14-${MY_PV}.zip )
			)
			font_variants_term? (
				${SRC_URI}ttf-unhinted-${PN}-term-${MY_PV}.zip
				font_variants_ss01? ( ${SRC_URI}ttf-unhinted-${PN}-term-ss01-${MY_PV}.zip )
				font_variants_ss02? ( ${SRC_URI}ttf-unhinted-${PN}-term-ss02-${MY_PV}.zip )
				font_variants_ss03? ( ${SRC_URI}ttf-unhinted-${PN}-term-ss03-${MY_PV}.zip )
				font_variants_ss04? ( ${SRC_URI}ttf-unhinted-${PN}-term-ss04-${MY_PV}.zip )
				font_variants_ss05? ( ${SRC_URI}ttf-unhinted-${PN}-term-ss05-${MY_PV}.zip )
				font_variants_ss06? ( ${SRC_URI}ttf-unhinted-${PN}-term-ss06-${MY_PV}.zip )
				font_variants_ss07? ( ${SRC_URI}ttf-unhinted-${PN}-term-ss07-${MY_PV}.zip )
				font_variants_ss08? ( ${SRC_URI}ttf-unhinted-${PN}-term-ss08-${MY_PV}.zip )
				font_variants_ss09? ( ${SRC_URI}ttf-unhinted-${PN}-term-ss09-${MY_PV}.zip )
				font_variants_ss10? ( ${SRC_URI}ttf-unhinted-${PN}-term-ss10-${MY_PV}.zip )
				font_variants_ss11? ( ${SRC_URI}ttf-unhinted-${PN}-term-ss11-${MY_PV}.zip )
				font_variants_ss12? ( ${SRC_URI}ttf-unhinted-${PN}-term-ss12-${MY_PV}.zip )
				font_variants_ss13? ( ${SRC_URI}ttf-unhinted-${PN}-term-ss13-${MY_PV}.zip )
				font_variants_ss14? ( ${SRC_URI}ttf-unhinted-${PN}-term-ss14-${MY_PV}.zip )
			)
			font_variants_slab? (
				font_variants_default? ( ${SRC_URI}ttf-unhinted-${PN}-slab-${MY_PV}.zip )
				font_variants_fixed? ( ${SRC_URI}ttf-unhinted-${PN}-fixed-slab-${MY_PV}.zip )
				font_variants_term? ( ${SRC_URI}ttf-unhinted-${PN}-term-slab-${MY_PV}.zip )
			)
			font_variants_curly? (
				font_variants_default? ( ${SRC_URI}ttf-unhinted-${PN}-curly-${MY_PV}.zip )
				font_variants_fixed? ( ${SRC_URI}ttf-unhinted-${PN}-fixed-curly-${MY_PV}.zip )
				font_variants_term? ( ${SRC_URI}ttf-unhinted-${PN}-term-curly-${MY_PV}.zip )
				font_variants_slab? (
					${SRC_URI}ttf-unhinted-${PN}-curly-slab-${MY_PV}.zip
					font_variants_fixed? ( ${SRC_URI}ttf-unhinted-${PN}-fixed-curly-slab-${MY_PV}.zip )
					font_variants_term? ( ${SRC_URI}ttf-unhinted-${PN}-term-curly-slab-${MY_PV}.zip )
				)
			)
			font_variants_ss01? ( ${SRC_URI}ttf-unhinted-${PN}-ss01-${MY_PV}.zip )
			font_variants_ss02? ( ${SRC_URI}ttf-unhinted-${PN}-ss02-${MY_PV}.zip )
			font_variants_ss03? ( ${SRC_URI}ttf-unhinted-${PN}-ss03-${MY_PV}.zip )
			font_variants_ss04? ( ${SRC_URI}ttf-unhinted-${PN}-ss04-${MY_PV}.zip )
			font_variants_ss05? ( ${SRC_URI}ttf-unhinted-${PN}-ss05-${MY_PV}.zip )
			font_variants_ss06? ( ${SRC_URI}ttf-unhinted-${PN}-ss06-${MY_PV}.zip )
			font_variants_ss07? ( ${SRC_URI}ttf-unhinted-${PN}-ss07-${MY_PV}.zip )
			font_variants_ss08? ( ${SRC_URI}ttf-unhinted-${PN}-ss08-${MY_PV}.zip )
			font_variants_ss09? ( ${SRC_URI}ttf-unhinted-${PN}-ss09-${MY_PV}.zip )
			font_variants_ss10? ( ${SRC_URI}ttf-unhinted-${PN}-ss10-${MY_PV}.zip )
			font_variants_ss11? ( ${SRC_URI}ttf-unhinted-${PN}-ss11-${MY_PV}.zip )
			font_variants_ss12? ( ${SRC_URI}ttf-unhinted-${PN}-ss12-${MY_PV}.zip )
			font_variants_ss13? ( ${SRC_URI}ttf-unhinted-${PN}-ss13-${MY_PV}.zip )
			font_variants_ss14? ( ${SRC_URI}ttf-unhinted-${PN}-ss14-${MY_PV}.zip )
			font_variants_aile? ( ${SRC_URI}ttf-unhinted-${PN}-aile-${MY_PV}.zip )
			font_variants_etoile? ( ${SRC_URI}ttf-unhinted-${PN}-etoile-${MY_PV}.zip )
			font_variants_sparkle? ( ${SRC_URI}ttf-unhinted-${PN}-sparkle-${MY_PV}.zip )
		)
	)
	font_types_ttc? (
			font_variants_default? ( ${SRC_URI}ttc-${PN}-${MY_PV}.zip )
			font_variants_curly? ( ${SRC_URI}ttc-${PN}-curly-${MY_PV}.zip )
			font_variants_slab? (
				${SRC_URI}ttc-${PN}-slab-${MY_PV}.zip
				font_variants_curly? ( ${SRC_URI}ttc-${PN}-curly-slab-${MY_PV}.zip )
				)
			font_variants_aile? ( ${SRC_URI}ttc-${PN}-aile-${MY_PV}.zip )
			font_variants_etoile? ( ${SRC_URI}ttc-${PN}-etoile-${MY_PV}.zip )
			font_variants_sparkle? ( ${SRC_URI}ttc-${PN}-sparkle-${MY_PV}.zip )
			font_variants_ss01? ( ${SRC_URI}ttc-${PN}-ss01-${MY_PV}.zip )
			font_variants_ss02? ( ${SRC_URI}ttc-${PN}-ss02-${MY_PV}.zip )
			font_variants_ss03? ( ${SRC_URI}ttc-${PN}-ss03-${MY_PV}.zip )
			font_variants_ss04? ( ${SRC_URI}ttc-${PN}-ss04-${MY_PV}.zip )
			font_variants_ss05? ( ${SRC_URI}ttc-${PN}-ss05-${MY_PV}.zip )
			font_variants_ss06? ( ${SRC_URI}ttc-${PN}-ss06-${MY_PV}.zip )
			font_variants_ss07? ( ${SRC_URI}ttc-${PN}-ss07-${MY_PV}.zip )
			font_variants_ss08? ( ${SRC_URI}ttc-${PN}-ss08-${MY_PV}.zip )
			font_variants_ss09? ( ${SRC_URI}ttc-${PN}-ss09-${MY_PV}.zip )
			font_variants_ss10? ( ${SRC_URI}ttc-${PN}-ss10-${MY_PV}.zip )
			font_variants_ss11? ( ${SRC_URI}ttc-${PN}-ss11-${MY_PV}.zip )
			font_variants_ss12? ( ${SRC_URI}ttc-${PN}-ss12-${MY_PV}.zip )
			font_variants_ss13? ( ${SRC_URI}ttc-${PN}-ss13-${MY_PV}.zip )
			font_variants_ss14? ( ${SRC_URI}ttc-${PN}-ss14-${MY_PV}.zip )
	)
	)
	!binary? (
		mirror://githubcl/be5invis/${PN}/tar.gz/v${MY_PV} -> ${P}.tar.gz
	)
	"
	RESTRICT="primaryuri"
	BDEPEND="binary? ( app-arch/unzip )"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/${PN^}-${MY_PV}"
fi
inherit font-r1

DESCRIPTION="Spatial efficient monospace font family for programming"
HOMEPAGE="https://be5invis.github.io/Iosevka"

LICENSE="OFL-1.1"
SLOT="0"
IUSE="
+autohint
+binary
"
REQUIRED_USE+="
?? ( ${MY_FONT_TYPES[@]/#+/} )
|| ( ${MY_FONT_VARIANTS[@]/#+/} )
"
BDEPEND+="
	!binary? (
		net-libs/nodejs[npm]
		autohint? ( media-gfx/ttfautohint )
		dev-util/otfcc
		dev-util/afdko
	)
"
PATCHES=( "${FILESDIR}"/${PN}-buildttc.diff )

pkg_setup() {
	if use binary; then
		S="${WORKDIR}"
		PATCHES=()
	fi
	font-r1_pkg_setup
}

src_prepare() {
	default
	use binary && return
	sed -e '/ttf2woff/d' -i package.json
	npm install
}

src_compile() {
	use binary && return

	local -x MAKE="npm run build" MAKEOPTS="--verbose --"
	local _s _t=()

	if use font_types_ttc; then

		if use font_variants_default; then
			_t+=( ${PN} )
			FONT_S+=( .build/ttc-collect/${PN}/ttc )
		fi
		for _s in ${FONT_VARIANTS[@]/default/}; do
			if use font_variants_${_s}; then
				_t+=( ${PN}-${_s} )
				FONT_S+=( .build/ttc-collect/${PN}-${_s}/ttc )
			fi
		done
		if use font_variants_slab && use font_variants_curly; then
			_t+=( ${PN}-curly-slab )
			FONT_S+=( .build/ttc-collect/${PN}-curly-slab/ttc )
		fi
		emake "${_t[@]/#/collection-export::}"

	else

		local _v="ttf$(usex autohint '' '-unhinted')"

		for _s in ${FONT_VARIANTS[@]}; do
				_s=${_s#default}
				_t+=( ${PN}-${_s} )
		done
		if use font_variants_slab; then
			use font_variants_fixed && _t+=( ${PN}-fixed-slab )
			use font_variants_term && _t+=( ${PN}-term-slab )
			if use font_variants_curly; then
				_t+=( ${PN}-curly-slab )
				use font_variants_fixed && _t+=( ${PN}-fixed-curly-slab )
				use font_variants_term && _t+=( ${PN}-term-curly-slab )
			fi
		fi
		if use font_variants_curly; then
			use font_variants_fixed && _t+=( ${PN}-fixed-curly )
			use font_variants_term && _t+=( ${PN}-term-curly )
		fi

		_t=( ${_t[@]/%-} )
		emake "${_t[@]/#/${_v}::}"

		FONT_S=( ${_t[@]/#/dist/} )
		FONT_S=( ${FONT_S[@]/%//${_v}} )
	fi
}
