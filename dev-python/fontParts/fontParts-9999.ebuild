# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8} )
inherit distutils-r1
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/robotools/${PN}.git"
else
	MY_PV="v${PV}"
	if [[ -z ${PV%%*_p*} ]]; then
		inherit vcs-snapshot
		MY_PV="9f6ff05"
	fi
	SRC_URI="
		mirror://githubcl/robotools/${PN}/tar.gz/${MY_PV}
		-> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="An API for interacting with the parts of fonts"
HOMEPAGE="https://github.com/robotools/${PN}"

LICENSE="MIT"
SLOT="0"
IUSE="test"

RDEPEND="
	>=dev-python/fonttools-4.2.1[ufo(-),unicode(-),${PYTHON_USEDEP}]
	dev-python/fontMath[${PYTHON_USEDEP}]
	dev-python/defcon[${PYTHON_USEDEP}]
	dev-python/booleanOperations[${PYTHON_USEDEP}]
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	test? ( dev-python/fontPens[${PYTHON_USEDEP}] )
"

python_test() {
	"${EPYTHON}" Lib/fontParts/fontshell/test.py -v || die \
		"Tests failed with ${EPYTHON}"
}
