# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

FONT_TYPES="otf ttf"
PYTHON_COMPAT=( python2_7 )
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/EbenSorkin/${PN}.git"
else
	inherit vcs-snapshot
	MY_PV="01c1811"
	SRC_URI="
		mirror://githubcl/EbenSorkin/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi
inherit python-any-r1 font-r1

DESCRIPTION="A serif font useful for creating long texts for books or articles"
HOMEPAGE="https://github.com/EbenSorkin/${PN}"

LICENSE="OFL-1.1"
SLOT="0"
IUSE="
	$(printf '+font_types_%s ' ${FONT_TYPES})
"
REQUIRED_USE+=" || ( $(printf 'font_types_%s ' ${FONT_TYPES}) )"

DEPEND="
	${PYTHON_DEPS}
	$(python_gen_any_dep '
		dev-util/fontmake[${PYTHON_USEDEP}]
	')
"
FONT_S=( master_{o,t}tf )

pkg_setup() {
	local t
	for t in ${FONT_TYPES}; do
		use font_types_${t} && FONT_SUFFIX+="${t} "
	done
	python-any-r1_pkg_setup
	font-r1_pkg_setup
}

src_compile() {
	fontmake \
		--ufo-paths "${S}"/SRC/${PN/-/}*.ufo \
		-o ${FONT_SUFFIX} \
		|| die
}
