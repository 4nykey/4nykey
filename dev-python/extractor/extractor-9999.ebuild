# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{5,6,7} )
inherit distutils-r1
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/typesupply/${PN}.git"
else
	inherit vcs-snapshot
	MY_PV="69f55a5"
	[[ -n ${PV%%*_p*} ]] && MY_PV="v${PV}"
	SRC_URI="
		mirror://githubcl/typesupply/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="Tools for extracting data from font binaries into UFO objects"
HOMEPAGE="https://github.com/typesupply/${PN}"

LICENSE="MIT"
SLOT="0"
IUSE="test"

RDEPEND="
	>=dev-python/fonttools-3.31[${PYTHON_USEDEP}]
"
DEPEND="
	${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( dev-python/pytest[${PYTHON_USEDEP}] )
"
PATCHES=( "${FILESDIR}"/${PN}-ufolib.diff )

python_test() {
	esetup.py test
}
