# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

MY_PN="Kurale"
FONT_TYPES="otf ttf"
PYTHON_COMPAT=( python2_7 )
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/etunni/${PN}.git"
else
	inherit vcs-snapshot
	MY_PV="bb84431"
	SRC_URI="
		mirror://githubcl/etunni/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi
inherit python-any-r1 font-r1

DESCRIPTION="A Latin, Cyrillic and Devanagari typeface derived from Gabriela"
HOMEPAGE="https://github.com/etunni/${PN}"

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
		FONT_S=( fonts )
	else
		python-any-r1_pkg_setup
		FONT_S=( master_{o,t}tf )
	fi
	font-r1_pkg_setup
}

src_prepare() {
	default
	use binary || \
	sed \
		-e 's:color = (:colorObject = (:' \
		-i "${S}"/sources/${MY_PN}.glyphs
}

src_compile() {
	use binary && return
	fontmake \
		--glyphs-path "${S}"/sources/${MY_PN}.glyphs \
		-o ${FONT_SUFFIX} \
		|| die
}
