# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{10..12} )
MY_FONT_TYPES=( otf +ttf )
if [[ ${PV} == *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/akryukov/${PN}.git"
	REQUIRED_USE="!binary"
else
	MY_PV="v${PV}"
	MY_P="${PN}-${MY_PV#v}"
	SRC_URI="
	binary? (
		font_types_otf? (
		https://github.com/akryukov/${PN}/releases/download/${MY_PV}/${MY_P}.otf.zip
		)
		font_types_ttf? (
		https://github.com/akryukov/${PN}/releases/download/${MY_PV}/${MY_P}.ttf.zip
		)
	)
	!binary? (
		mirror://githubcl/akryukov/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	)
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi
inherit python-single-r1 font-r1

DESCRIPTION="A Greek font designed from historic samples"
HOMEPAGE="https://github.com/akryukov/${PN}"

LICENSE="OFL-1.1"
SLOT="0"
IUSE="+binary"

BDEPEND="
	binary? ( app-arch/unzip )
	!binary? (
		${PYTHON_DEPS}
		$(python_gen_cond_dep '
			media-gfx/fontforge[python,${PYTHON_SINGLE_USEDEP}]
		')
		font_types_ttf? ( dev-util/grcompiler )
	)
"

pkg_setup() {
	if use binary; then
		S="${WORKDIR}"
	else
		python-single-r1_pkg_setup
	fi
	font-r1_pkg_setup
}

src_compile() {
	use binary && return
	sed -e '/woff_meta =/,/filename + ".woff"/d' -i ${PN}-generate.py
	fontforge -lang=py -script ${PN}-generate.py || die
	use font_types_ttf || return
	local _t
	for _t in *.ttf; do
		grcompiler "${_t%.*}.gdl" "${_t}" "${T}/${_t}" || die
		mv -f "${T}/${_t}" "${_t}"
	done
}
