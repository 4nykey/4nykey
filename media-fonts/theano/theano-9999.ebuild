# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python2_7 )
FONT_TYPES="otf ttf"
if [[ ${PV} == *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/akryukov/${PN}.git"
	REQUIRED_USE="!binary"
else
	inherit vcs-snapshot
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
inherit python-any-r1 font

DESCRIPTION="A Greek font designed from historic samples"
HOMEPAGE="https://github.com/akryukov/${PN}"

LICENSE="OFL-1.1"
SLOT="0"
IUSE="
	+binary
	$(printf '+font_types_%s ' ${FONT_TYPES})
"
REQUIRED_USE+=" || ( $(printf 'font_types_%s ' ${FONT_TYPES}) )"

DEPEND="
	binary? ( app-arch/unzip )
	!binary? (
		${PYTHON_DEPS}
		$(python_gen_any_dep '
			media-gfx/fontforge[${PYTHON_USEDEP}]
		')
		font_types_ttf? ( dev-util/grcompiler )
	)
"
RDEPEND=""

pkg_setup() {
	local t
	for t in ${FONT_TYPES}; do
		use font_types_${t} && FONT_SUFFIX+="${t} "
	done

	if use binary; then
		S="${WORKDIR}"
		FONT_S="${S}"
	else
		python-any-r1_pkg_setup
		DOCS+=" README.md"
	fi
	font_pkg_setup
}

src_compile() {
	use binary && return
	fontforge -lang=py -script ${PN}-generate.py || die
	use font_types_ttf || return
	local _t
	for _t in *.ttf; do
		grcompiler "${_t%.*}.gdl" "${_t}" "${T}/${_t}" || die
		mv -f "${T}/${_t}" "${_t}"
	done
}
