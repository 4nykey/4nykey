# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{3,4,5} )
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/alexeiva/${PN}.git"
else
	inherit vcs-snapshot
	MY_PV="7bdd67f"
	SRC_URI="
		mirror://githubcl/alexeiva/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi
inherit python-any-r1 font

DESCRIPTION="A family of sans-serif fonts in the Eurostile vein"
HOMEPAGE="http://danieljohnson.name/fonts/jura https://github.com/alexeiva/jura"

LICENSE="GPL-3 OFL-1.1"
SLOT="0"
IUSE="+binary"

DEPEND="
	!binary? (
		${PYTHON_DEPS}
		$(python_gen_any_dep '
			media-gfx/fontforge[${PYTHON_USEDEP}]
		')
	)
"
RDEPEND=""
FONT_SUFFIX="otf"
DOCS+=" README.md"

pkg_setup() {
	if use binary; then
		FONT_S="${S}/fonts/otf"
	else
		python-any-r1_pkg_setup
		FONT_S="${S}/master_otf"
	fi
	font_pkg_setup
}

src_compile() {
	use binary && return
	fontmake \
		--glyphs-path sources/1-drawing/Jura.glyphs \
		--output otf || die
}
