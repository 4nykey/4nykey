# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

FONT_TYPES="otf ttf"
PYTHON_COMPAT=( python2_7 )
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/clauseggers/${PN}.git"
else
	inherit vcs-snapshot
	SRC_URI="
		mirror://githubcl/clauseggers/${PN}/tar.gz/${PV} -> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi
inherit python-any-r1 font

DESCRIPTION="An Open Source typeface family for display and titling use"
HOMEPAGE="https://github.com/clauseggers/${PN}"

LICENSE="OFL-1.1"
SLOT="0"
IUSE="
	+binary
	$(printf '+font_types_%s ' ${FONT_TYPES})
"
REQUIRED_USE+=" || ( $(printf 'font_types_%s ' ${FONT_TYPES}) )"

DEPEND="
	!binary? (
		${PYTHON_DEPS}
		$(python_gen_any_dep '
			dev-util/fontmake[${PYTHON_USEDEP}]
		')
	)
"

DOCS+=" README.md"

pkg_setup() {
	local t
	for t in ${FONT_TYPES}; do
		use font_types_${t} && FONT_SUFFIX+="${t} "
	done
	use binary || python-any-r1_pkg_setup
	font_pkg_setup
}

src_prepare() {
	default
	mv -f "${S}"/{CFF,TTF}/*.[ot]tf "${FONT_S}"/
}

src_compile() {
	use binary && return
	local g
	for g in "${S}"/Glyphs/*.glyphs; do
		fontmake \
			--glyphs-path "${g}" \
			--interpolate \
			-o ${FONT_SUFFIX} \
			|| die
	done
	for t in ${FONT_SUFFIX}; do
		mv -f "${S}"/instance_${t}/*.${t} "${FONT_S}"/
	done
}
