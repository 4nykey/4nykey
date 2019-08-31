# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_FONT_TYPES=( ttc +ttf )
MY_FONT_VARIANTS=(
	cc
	+default
	slab
	term
	type
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
)
if [[ ${PV} == *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/be5invis/${PN}.git"
	REQUIRED_USE="!binary"
else
	SRC_URI="https://github.com/be5invis/${PN^}/releases/download/v${PV}/"
	SRC_URI="
	binary? (
	font_types_ttf? (
		font_variants_default? ( ${SRC_URI}/01-${P}.zip )
		font_variants_term? (
			${SRC_URI}/02-${PN}-term-${PV}.zip
			font_variants_ss01? ( ${SRC_URI}/${PN}-term-ss01-${PV}.zip )
			font_variants_ss02? ( ${SRC_URI}/${PN}-term-ss02-${PV}.zip )
			font_variants_ss03? ( ${SRC_URI}/${PN}-term-ss03-${PV}.zip )
			font_variants_ss04? ( ${SRC_URI}/${PN}-term-ss04-${PV}.zip )
			font_variants_ss05? ( ${SRC_URI}/${PN}-term-ss05-${PV}.zip )
			font_variants_ss06? ( ${SRC_URI}/${PN}-term-ss06-${PV}.zip )
			font_variants_ss07? ( ${SRC_URI}/${PN}-term-ss07-${PV}.zip )
			font_variants_ss08? ( ${SRC_URI}/${PN}-term-ss08-${PV}.zip )
			font_variants_ss09? ( ${SRC_URI}/${PN}-term-ss09-${PV}.zip )
			font_variants_ss10? ( ${SRC_URI}/${PN}-term-ss10-${PV}.zip )
			font_variants_ss11? ( ${SRC_URI}/${PN}-term-ss11-${PV}.zip )
		)
		font_variants_type? ( ${SRC_URI}/03-${PN}-type-${PV}.zip )
		font_variants_cc? ( ${SRC_URI}/04-${PN}-cc-${PV}.zip )
		font_variants_slab? (
			font_variants_default? ( ${SRC_URI}/05-${PN}-slab-${PV}.zip )
			font_variants_term? ( ${SRC_URI}/06-${PN}-term-slab-${PV}.zip )
			font_variants_type? ( ${SRC_URI}/07-${PN}-type-slab-${PV}.zip )
			font_variants_cc? ( ${SRC_URI}/08-${PN}-cc-slab-${PV}.zip )
		)
		font_variants_ss01? ( ${SRC_URI}/${PN}-ss01-${PV}.zip )
		font_variants_ss02? ( ${SRC_URI}/${PN}-ss02-${PV}.zip )
		font_variants_ss03? ( ${SRC_URI}/${PN}-ss03-${PV}.zip )
		font_variants_ss04? ( ${SRC_URI}/${PN}-ss04-${PV}.zip )
		font_variants_ss05? ( ${SRC_URI}/${PN}-ss05-${PV}.zip )
		font_variants_ss06? ( ${SRC_URI}/${PN}-ss06-${PV}.zip )
		font_variants_ss07? ( ${SRC_URI}/${PN}-ss07-${PV}.zip )
		font_variants_ss08? ( ${SRC_URI}/${PN}-ss08-${PV}.zip )
		font_variants_ss09? ( ${SRC_URI}/${PN}-ss09-${PV}.zip )
		font_variants_ss10? ( ${SRC_URI}/${PN}-ss10-${PV}.zip )
		font_variants_ss11? ( ${SRC_URI}/${PN}-ss11-${PV}.zip )
	)
	font_types_ttc? (
			${SRC_URI}/ttc-${P}.zip
			font_variants_slab? ( ${SRC_URI}/ttc-${PN}-slab-${PV}.zip )
	)
	)
	!binary? (
		mirror://githubcl/be5invis/${PN}/tar.gz/v${PV} -> ${P}.tar.gz
	)
	"
	RESTRICT="primaryuri"
	BDEPEND="binary? ( app-arch/unzip )"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/${PN^}-${PV}"
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
font_variants_slab? ( || (
	font_variants_default
	font_variants_cc
	font_variants_term
	font_variants_type
) )
"
BDEPEND+="
	!binary? (
		net-libs/nodejs[npm]
		autohint? ( media-gfx/ttfautohint )
		dev-util/otfcc
	)
"

pkg_setup() {
	if use binary; then
		S="${WORKDIR}"
		use font_types_ttf && FONT_S="ttf$(usex autohint '' '-unhinted')"
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

	if use font_types_ttc; then

		emake collection-fonts::${PN}
		use font_variants_slab && emake collection-fonts::${PN}-slab
		FONT_S=( dist/collections/${PN}{,-slab} )

	elif use font_types_ttf; then

		local _s _t _v="ttf$(usex autohint '' '-unhinted')"
		if use font_variants_default; then
			_t+=( ${PN} )
		fi
		use font_variants_cc && _t+=( ${PN}-cc )
		if use font_variants_term; then
			_t+=( ${PN}-term )
			for _s in $(seq -w 11); do
				use font_variants_ss${_s} && _t+=( ${PN}-term-ss${_s} )
			done
		fi
		use font_variants_type && _t+=( ${PN}-type )
		if use font_variants_slab; then
			use font_variants_default && _t+=( ${PN}-slab )
			use font_variants_cc && _t+=( ${PN}-cc-slab )
			use font_variants_term && _t+=( ${PN}-term-slab )
			use font_variants_type && _t+=( ${PN}-type-slab )
		fi
		for _s in $(seq -w 11); do
			use font_variants_ss${_s} && _t+=( ${PN}-ss${_s} )
		done

		emake ${_t[@]/#/${_v}::}

		FONT_S=( ${_t[@]/#/dist/} )
		FONT_S=( ${FONT_S[@]/%//${_v}} )

	fi
}
