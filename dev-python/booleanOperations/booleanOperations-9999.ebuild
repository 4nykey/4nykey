# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{4,5,6} )
inherit distutils-r1
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/typemytype/${PN}.git"
else
	inherit vcs-snapshot
	MY_PV="0a9cc5c"
	[[ -n ${PV%%*_p*} ]] && MY_PV="${PV}"
	SRC_URI="
		mirror://githubcl/typemytype/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="A library for boolean operations on paths"
HOMEPAGE="https://github.com/typemytype/${PN}"

LICENSE="MIT"
SLOT="0"
IUSE="test"

RDEPEND="
	dev-python/pyclipper[${PYTHON_USEDEP}]
	dev-python/fonttools[${PYTHON_USEDEP}]
	dev-python/ufoLib[${PYTHON_USEDEP}]
"
DEPEND="
	${RDEPEND}
	test? ( dev-python/pytest-runner[${PYTHON_USEDEP}] )
"

python_prepare_all() {
	local _v="${PV%_p*}"
	[[ -z ${PV%%*9999} ]] && _v="$(git describe --tags)"
	sed \
		-e '/setuptools_scm/d' \
		-e "s:use_scm_version=True:version=\"${_v}\":" \
		-i "${S}"/setup.py
	distutils-r1_python_prepare_all
}

python_test() {
	esetup.py test
}
