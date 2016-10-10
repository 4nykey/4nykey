# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

FONT_TYPES="otf ttf"
PYTHON_COMPAT=( python2_7 )
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/tonsky/${PN}"
else
	SRC_URI="mirror://githubcl/tonsky/${PN}/tar.gz/${PV} -> ${P}.tar.gz"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi
inherit python-any-r1 font

DESCRIPTION="A monospaced font with programming ligatures"
HOMEPAGE="https://github.com/tonsky/${PN}"

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
RDEPEND="${DEPEND}"
DOCS=( README.md )

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
	use binary && return
	sed -e 's:\\\\::g' -i FiraCode.glyphs || die
}

src_compile() {
	if use binary; then
		mv -f "${S}"/distr/[ot]tf/*.[ot]tf "${S}"/
	else
		local t=" -o ${FONT_SUFFIX}"
		[[ ${#t} -eq 8 ]] || t=
		fontmake \
			--glyphs-path "${S}"/${PN}.glyphs \
			--interpolate \
			${t} \
			|| die
		for t in ${FONT_SUFFIX}; do
			mv -f "${S}"/instance_${t}/*.${t} "${S}"/
		done
	fi
}
