# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{4,5,6,7} )
inherit distutils-r1
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/robofab-developers/${PN}.git"
else
	inherit vcs-snapshot
	MY_PV="c1da711"
	[[ -n ${PV%%*_p*} ]] && MY_PV="v${PV}"
	SRC_URI="
		mirror://githubcl/robofab-developers/${PN}/tar.gz/${MY_PV}
		-> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="A collection of classes implementing the pen protocol for manipulating glyphs"
HOMEPAGE="https://github.com/robofab-developers/${PN}"

LICENSE="BSD"
SLOT="0"
IUSE="test"

RDEPEND="
	>=dev-python/fonttools-3.31[ufo,${PYTHON_USEDEP}]
	dev-python/fontParts[${PYTHON_USEDEP}]
"
DEPEND="
	${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( dev-python/pytest[${PYTHON_USEDEP}] )
"

python_test() {
	pytest || die "Tests failed with ${EPYTHON}"
}
