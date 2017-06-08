# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )
FONT_TYPES=( otf +ttf )
inherit python-any-r1 font-r1
if [[ ${PV} == *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/georgd/${PN}.git"
else
	inherit vcs-snapshot
	MY_PV="3590428"
	SRC_URI="
		mirror://githubcl/georgd/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="This project aims at providing a free version of the Garamond typeface"
HOMEPAGE="http://www.georgduffner.at/ebgaramond"

LICENSE="OFL-1.1"
SLOT="0"

DEPEND="
	${PYTHON_DEPS}
	$(python_gen_any_dep '
		media-gfx/fontforge[${PYTHON_USEDEP}]
	')
	font_types_ttf? ( media-gfx/ttfautohint )
"
FONT_S=( build )
DOCS="Changes specimen/Specimen.pdf"

pkg_setup() {
	python-any-r1_pkg_setup
	font-r1_pkg_setup
}

src_compile() {
	emake \
		${FONT_SUFFIX} \
		PY=${PYTHON}
}
