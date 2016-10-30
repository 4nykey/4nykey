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
inherit python-any-r1 font-r1

DESCRIPTION="An open-source font by Jan Gerner"
HOMEPAGE="https://github.com/alexeiva/${PN}"

LICENSE="OFL-1.1"
SLOT="0"
IUSE="+binary"

DEPEND="
	!binary? (
		${PYTHON_DEPS}
		$(python_gen_any_dep '
			dev-util/fontmake[${PYTHON_USEDEP}]
		')
	)
"

pkg_setup() {
	if use binary; then
		FONT_S=( fonts/{o,t}tf )
	else
		python-any-r1_pkg_setup
		FONT_S=( instance_{o,t}tf )
	fi
	font-r1_pkg_setup
}

src_compile() {
	use binary && return
	fontmake \
		--glyphs-path "${S}"/sources/Yanone-Kaffeesatz-MM.glyphs \
		--interpolate \
		-o ${FONT_SUFFIX} || die
}
