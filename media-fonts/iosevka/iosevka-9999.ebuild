# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python2_7 )
FONT_VARIANTS=( cc slab term )
FONT_CHARS=( hooky zshaped )
if [[ ${PV} == *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/be5invis/${PN}.git"
	REQUIRED_USE="!binary"
else
	inherit vcs-snapshot
	SRC_URI="https://github.com/be5invis/${PN^}/releases/download/v${PV}/"
	SRC_URI="
	binary? (
		font_variants_default? ( ${SRC_URI}/01.${P}.zip )
		font_variants_term? ( ${SRC_URI}/02.${PN}-term-${PV}.zip )
		font_variants_cc? ( ${SRC_URI}/03.${PN}-cc-${PV}.zip )
		font_variants_slab? (
			${SRC_URI}/04.${PN}-slab-${PV}.zip
			font_variants_term? ( ${SRC_URI}/05.${PN}-term-slab-${PV}.zip )
			font_variants_cc? ( ${SRC_URI}/06.${PN}-cc-slab-${PV}.zip )
		)
		font_chars_hooky? (
			${SRC_URI}/07.${PN}-hooky-${PV}.zip
			font_variants_term? ( ${SRC_URI}/08.${PN}-term-hooky-${PV}.zip )
		)
		font_chars_zshaped? (
			${SRC_URI}/09.${PN}-zshaped-${PV}.zip
			font_variants_term? ( ${SRC_URI}/10.${PN}-term-zshaped-${PV}.zip )
		)
	)
	!binary? (
		mirror://githubcl/be5invis/${PN}/tar.gz/v${PV} -> ${P}.tar.gz
	)
	"
	RESTRICT="primaryuri"
	DEPEND="binary? ( app-arch/unzip )"
	KEYWORDS="~amd64 ~x86"
fi
inherit python-any-r1 font-r1

DESCRIPTION="Spatial efficient monospace font family for programming"
HOMEPAGE="https://be5invis.github.io/Iosevka"

LICENSE="OFL-1.1"
SLOT="0"
IUSE="
+binary
+font_variants_default
${FONT_VARIANTS[@]/#/font_variants_}
${FONT_CHARS[@]/#/font_chars_}
+autohint
"

DEPEND+="
	!binary? (
		${PYTHON_DEPS}
		$(python_gen_any_dep '
			media-gfx/fontforge[${PYTHON_USEDEP}]
		')
		>=net-libs/nodejs-6.0[npm]
		autohint? ( media-gfx/ttfautohint )
		dev-util/otfcc
	)
"

pkg_setup() {
	if use binary; then
		S="${WORKDIR}"
	else
		python-any-r1_pkg_setup
	fi
	font-r1_pkg_setup
}

src_compile() {
	use binary && return
	local _c _t _v
	for _v in ${FONT_VARIANTS[@]} default; do
		use font_variants_${_v} && _t+=( fonts-${_v} )
	done
	for _v in ${FONT_CHARS[@]}; do
		if use font_chars_${_v}; then
			_t+=( fonts-${_v} )
			use font_variants_term && _t+=( fonts-${_v}-term )
		fi
	done
	if use font_variants_slab; then
		use font_variants_cc && _t+=( fonts-cc-slab )
		use font_variants_term && _t+=( fonts-term-slab )
	fi
	npm install
	emake $(usex autohint '' DONTHINT=1) ${_t[@]}
	FONT_S=( $(find dist -type d -name "[01][0-9].${PN}*") )
}
