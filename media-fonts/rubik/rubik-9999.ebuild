# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{3,4,5} )
if [[ ${PV} == *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/googlefonts/${PN}.git"
else
	inherit vcs-snapshot
	MY_PV="7581645"
	SRC_URI="
		mirror://githubcl/googlefonts/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi
inherit python-any-r1 font

DESCRIPTION="Rubik fonts"
HOMEPAGE="https://github.com/googlefonts/${PN}"

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

FONT_SUFFIX="otf"
DOCS="AUTHORS.txt CONTRIBUTORS.txt README.md"

pkg_setup() {
	use binary || python-any-r1_pkg_setup
	font_pkg_setup
}

src_prepare() {
	default
	use binary && mv "${S}"/4_fonts/otf/*.otf "${FONT_S}"
}

src_compile() {
	use binary && return

	fontmake \
		--output otf \
		--ufo-paths "${S}"/2_sources/*.ufo || die
	mv "${S}"/master_otf/*.otf "${FONT_S}"
}
