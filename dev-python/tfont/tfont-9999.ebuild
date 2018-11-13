# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_{4,5,6,7} )
inherit distutils-r1
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/trufont/${PN}.git"
else
	inherit vcs-snapshot
	MY_PV="5c85abd"
	[[ -n ${PV%%*_p*} ]] && MY_PV="v${PV}"
	SRC_URI="
		mirror://githubcl/trufont/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="A font library that writes to JSON"
HOMEPAGE="https://github.com/trufont/${PN}"

LICENSE="Apache-2.0"
SLOT="0"
IUSE="test"

RDEPEND="
	>=dev-python/fonttools-3.24[${PYTHON_USEDEP}]
	dev-python/python-rapidjson[${PYTHON_USEDEP}]
	dev-python/ufoLib2[${PYTHON_USEDEP}]
	dev-python/cattrs[${PYTHON_USEDEP}]
"
DEPEND="
	${RDEPEND}
	dev-python/setuptools_scm[${PYTHON_USEDEP}]
	test? ( dev-python/pytest[${PYTHON_USEDEP}] )
"

pkg_setup() {
	[[ -n ${PV%%*9999} ]] && export SETUPTOOLS_SCM_PRETEND_VERSION="${PV%_*}"
}

python_test() {
	esetup.py test
}
