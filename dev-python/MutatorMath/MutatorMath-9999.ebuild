# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{4,5,6,7} )
inherit distutils-r1
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/LettError/${PN}.git"
else
	inherit vcs-snapshot
	MY_PV="ac9af54"
	[[ -n ${PV%%*_p*} ]] && MY_PV="${PV}"
	SRC_URI="
		mirror://githubcl/LettError/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="A library for piecewise linear interpolation in multiple dimensions"
HOMEPAGE="https://github.com/LettError/${PN}"

LICENSE="BSD"
SLOT="0"
IUSE="test"

RDEPEND="
	>=dev-python/fonttools-3.32[ufo,${PYTHON_USEDEP}]
	dev-python/defcon[${PYTHON_USEDEP}]
	dev-python/fontMath[${PYTHON_USEDEP}]
"
DEPEND="
	${RDEPEND}
	test? ( dev-python/pytest[${PYTHON_USEDEP}] )
"

python_test() {
	esetup.py test
}
