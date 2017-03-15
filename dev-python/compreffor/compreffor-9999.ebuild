# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{4,5} )
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/googlei18n/${PN}.git"
else
	inherit vcs-snapshot
	MY_PV="b30b5ba"
	[[ -n ${PV%%*_p*} ]] && MY_PV="${PV}"
	SRC_URI="
		mirror://githubcl/googlei18n/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi
inherit distutils-r1

DESCRIPTION="A CFF table subroutinizer for FontTools"
HOMEPAGE="https://github.com/googlei18n/${PN}"

LICENSE="Apache-2.0"
SLOT="0"
IUSE="+cython test"

RDEPEND="
	>=dev-python/fonttools-3.5.0[${PYTHON_USEDEP}]
"
DEPEND="
	${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	cython? ( >=dev-python/cython-0.24[${PYTHON_USEDEP}] )
	test? ( dev-python/pytest-runner[${PYTHON_USEDEP}] )
"

src_prepare() {
	default
	use cython && rm -f "${S}"/src/cython/_compreffor.cpp
}

python_test() {
	esetup.py test || die
}
