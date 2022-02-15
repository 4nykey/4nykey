# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..10} )
MY_FONT_TYPES=( otf +ttf )
inherit python-single-r1 font-r1
if [[ ${PV} == *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/georgd/${PN}.git"
else
	MY_PV="d9d931d"
	MY_P="EBGaramond-${PV%_p*}"
	SRC_URI="
	!binary? (
		mirror://githubcl/georgd/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	)
	binary? (
		https://bitbucket.org/georgd/${PN}/downloads/${MY_P}.zip
	)
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="This project aims at providing a free version of the Garamond typeface"
HOMEPAGE="http://www.georgduffner.at/ebgaramond"

LICENSE="OFL-1.1"
SLOT="0"
IUSE="+binary"

BDEPEND="
	binary? (
		app-arch/unzip
	)
	!binary? (
		${PYTHON_DEPS}
		$(python_gen_cond_dep '
			media-gfx/fontforge[python,${PYTHON_SINGLE_USEDEP}]
		')
		font_types_ttf? ( media-gfx/ttfautohint )
	)
"
DOCS="Changes specimen/Specimen.pdf"

pkg_setup() {
	if use binary; then
		S="${WORKDIR}/${MY_P}"
		FONT_S=( otf ttf )
	else
		S="${WORKDIR}/EB-Garamond-${MY_PV}"
		FONT_S=( build )
		python-single-r1_pkg_setup
	fi
	font-r1_pkg_setup
}

src_compile() {
	use binary && return
	emake \
		${FONT_SUFFIX} \
		PY=${PYTHON}
}
