# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )
DISTUTILS_USE_PEP517=setuptools
DISTUTILS_SINGLE_IMPL=1
inherit distutils-r1
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/googlefonts/${PN}.git"
else
	MY_PV="c7a15ee"
	SRC_URI="
		mirror://githubcl/googlefonts/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/${PN}-${MY_PV}"
fi

DESCRIPTION="Tool to create PDF files containing glyph images and information about a font"
HOMEPAGE="https://github.com/googlefonts/${PN}"

LICENSE="Apache-2.0"
SLOT="0"
IUSE=""

RDEPEND="
	${PYTHON_DEPS}
	virtual/tex-base
	virtual/latex-base
	$(python_gen_cond_dep 'dev-python/fonttools[${PYTHON_USEDEP}]')
"
DEPEND="
	${RDEPEND}
"
