# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

FONT_TYPES="otf ttf"
PYTHON_COMPAT=( python2_7 )
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/alexeiva/${PN}.git"
else
	inherit vcs-snapshot
	MY_PV="83b5efb"
	SRC_URI="
		mirror://githubcl/alexeiva/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi
inherit python-any-r1 font

DESCRIPTION="An open-source font by Jan Gerner"
HOMEPAGE="https://github.com/alexeiva/${PN}"

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

DOCS+=" AUTHORS.txt CONTRIBUTORS.txt"

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
	use binary && \
	mv -f "${S}"/fonts/[ot]tf/*.[ot]tf "${FONT_S}"/
}

src_compile() {
	use binary && return
	fontmake \
		--glyphs-path "${S}"/sources/Yanone-Kaffeesatz-MM.glyphs \
		--interpolate \
		-o ${FONT_SUFFIX} || die
	for t in ${FONT_SUFFIX}; do
		mv -f "${S}"/instance_${t}/*.${t} "${FONT_S}"/
	done
}
