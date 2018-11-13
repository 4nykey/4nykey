# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_{4,5,6,7} )
inherit distutils-r1
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/schollii/${PN}.git"
	EGIT_SUBMODULES=( )
else
	inherit vcs-snapshot
	MY_PV="39a9c61"
	[[ -n ${PV%%*_p*} ]] && MY_PV="v${PV}"
	SRC_URI="
		mirror://githubcl/schollii/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="A Python publish-subcribe library"
HOMEPAGE="https://github.com/schollii/${PN}"

LICENSE="BSD"
SLOT="0"
IUSE="test"

RDEPEND="
"
DEPEND="
	${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( dev-python/pytest[${PYTHON_USEDEP}] )
"

python_test() {
	esetup.py test
}
