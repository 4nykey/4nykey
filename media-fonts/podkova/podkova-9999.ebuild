# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

FONT_TYPES="otf ttf"
FONT_TYPES_EXCLUDE="otf ttf"
PYTHON_COMPAT=( python2_7 )
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/cyrealtype/${PN}.git"
else
	inherit vcs-snapshot
	MY_PV="77cbf89"
	SRC_URI="
		mirror://githubcl/cyrealtype/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi
inherit python-any-r1 font-r1

DESCRIPTION="A monoline slab serif with diagonal terminals"
HOMEPAGE="https://github.com/cyrealtype/${PN}"

LICENSE="OFL-1.1"
SLOT="0"
IUSE="+binary"
REQUIRED_USE="binary? ( !font_types_otf )"

DEPEND="
	!binary? (
		${PYTHON_DEPS}
		$(python_gen_any_dep '
			dev-util/fontmake[${PYTHON_USEDEP}]
		')
	)
"

pkg_setup() {
	echo $USE
	if use binary; then
		FONT_S=( fonts )
	else
		python-any-r1_pkg_setup
		FONT_S=( master_{o,t}tf )
	fi
	font-r1_pkg_setup
}

src_compile() {
	use binary && return
	fontmake \
		--glyphs-path "${S}"/source/${PN^}*.glyphs \
		-o ${FONT_SUFFIX} \
		|| die
}
