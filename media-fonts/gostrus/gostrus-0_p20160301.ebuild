# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8} )
MY_FONT_TYPES=( otf +ttf )
inherit python-single-r1 font-r1

MY_PN="${PN}-type-a"
MY_MK="f9edc47e189d8495b647a4feac8ca240-1827636"
DESCRIPTION="A geometric Sans Serif typeface for technical documentation"
HOMEPAGE="https://fontlibrary.org/en/font/${MY_PN}"
SRC_URI="
	mirror://fontlibrary/${MY_PN}/281661436e74afb39383ecda10eb4135/${MY_PN}.zip
	-> ${P}.zip
	!binary? (
		mirror://githubcl/gist/${MY_MK%-*}/tar.gz/${MY_MK#*-}
		-> ${MY_MK}.tar.gz
	)
"
RESTRICT="primaryuri"

LICENSE="OFL-1.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+binary"
REQUIRED_USE="binary? ( !font_types_otf )"

BDEPEND="
	app-arch/unzip
	!binary? (
		${PYTHON_DEPS}
		$(python_gen_cond_dep '
			media-gfx/fontforge[python,${PYTHON_SINGLE_USEDEP}]
		')
	)
"
S="${WORKDIR}/GTRS_font"

pkg_setup() {
	use binary || python-single-r1_pkg_setup
	font-r1_pkg_setup
}

src_prepare() {
	default
	use binary || unpack ${MY_MK}.tar.gz
}

src_compile() {
	use binary && return
	local _t _s
	for _t in ${FONT_SUFFIX}; do
		for _s in "${S}"/GTRS_*.sfd; do
				fontforge -script ${MY_MK}/ffgen.py "${_s}" ${_t}
		done
	done
}
