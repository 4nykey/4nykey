# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

FONT_TYPES=( ttc +ttf )
FONT_VARIANTS=( cc +default slab term type )
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
	font_types_ttf? (
		font_variants_default? ( ${SRC_URI}/01-${P}.zip )
		font_variants_term? ( ${SRC_URI}/02-${PN}-term-${PV}.zip )
		font_variants_type? ( ${SRC_URI}/03-${PN}-type-${PV}.zip )
		font_variants_cc? ( ${SRC_URI}/04-${PN}-cc-${PV}.zip )
		font_variants_slab? (
			${SRC_URI}/05-${PN}-slab-${PV}.zip
			font_variants_term? ( ${SRC_URI}/06-${PN}-term-slab-${PV}.zip )
			font_variants_type? ( ${SRC_URI}/07-${PN}-type-slab-${PV}.zip )
			font_variants_cc? ( ${SRC_URI}/08-${PN}-cc-slab-${PV}.zip )
		)
		font_chars_hooky? (
			${SRC_URI}/09-${PN}-hooky-${PV}.zip
			font_variants_term? ( ${SRC_URI}/10-${PN}-hooky-term-${PV}.zip )
		)
		font_chars_zshaped? (
			${SRC_URI}/11-${PN}-zshaped-${PV}.zip
			font_variants_term? ( ${SRC_URI}/12-${PN}-zshaped-term-${PV}.zip )
		)
	)
	font_types_ttc? (
			${SRC_URI}/iosevka-pack-${PV}.zip
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
inherit font-r1

DESCRIPTION="Spatial efficient monospace font family for programming"
HOMEPAGE="https://be5invis.github.io/Iosevka"

LICENSE="OFL-1.1"
SLOT="0"
IUSE="
+binary
"
REQUIRED_USE+="
?? ( ${FONT_TYPES[@]/#+/} )
|| ( ${FONT_VARIANTS[@]/#+/} )
"

DEPEND+="
	!binary? (
		${PYTHON_DEPS}
		>=net-libs/nodejs-6.0[npm]
		media-gfx/ttfautohint
		dev-util/otfcc
		font_types_ttc? ( dev-util/otfcc-ttcize )
	)
"

pkg_setup() {
	use binary && S="${WORKDIR}"
	font-r1_pkg_setup
}

src_prepare() {
	default
	use binary || npm install
}

src_compile() {
	use binary && return

	emake build/targets.mk

	if use font_types_ttc; then
		emake -f utility/makefile.standard.mk ttc
		FONT_S=( dist/ttc )
		return
	fi

	local _t _v
	use font_variants_default && _t+=( r-sans )
	use font_variants_cc && _t+=( r-sans-cc )
	use font_variants_slab && _t+=( r-slab )
	use font_variants_term && _t+=( r-term )
	for _v in ${FONT_CHARS[@]/font_chars_}; do
		if use font_chars_${_v}; then
			_t+=( r-${_v} )
			use font_variants_term && _t+=( r-${_v}-term )
		fi
	done
	if use font_variants_slab; then
		use font_variants_cc && _t+=( r-slab-cc )
		use font_variants_term && _t+=( r-slab-term )
	fi

	emake -f utility/makefile.standard.mk ${_t[@]/#/fonts-}

	FONT_S=( $(find dist -type d -name "[01][0-9]-${PN}*") )
}
