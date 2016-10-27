# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python2_7 )
FONT_TYPES="otf ttf"
inherit python-any-r1 font-r1
if [[ ${PV} == *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://bitbucket.org/georgd/${PN}.git"
	DEPEND="
		${PYTHON_DEPS}
		$(python_gen_any_dep '
			media-gfx/fontforge[${PYTHON_USEDEP}]
		')
		media-gfx/ttfautohint
	"
else
	inherit vcs-snapshot
	MY_PV="3590428"
	SRC_URI="
		https://bitbucket.org/georgd/${PN}/get/${MY_PV}.tar.gz
		-> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="This project aims at providing a free version of the Garamond typeface"
HOMEPAGE="http://www.georgduffner.at/ebgaramond"

LICENSE="OFL-1.1"
SLOT="0"
IUSE="
	$(printf '+font_types_%s ' ${FONT_TYPES})
"
REQUIRED_USE+=" || ( $(printf 'font_types_%s ' ${FONT_TYPES}) )"

FONT_S="${S}/build"
DOCS="Changes specimen/Specimen.pdf"

pkg_setup() {
	local t
	for t in ${FONT_TYPES}; do
		use font_types_${t} && FONT_SUFFIX+="${t} "
	done
	python-any-r1_pkg_setup
	font-r1_pkg_setup
}

src_compile() {
	emake \
		${FONT_SUFFIX} \
		PY=${PYTHON}
}
