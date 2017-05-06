# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_{4,5} )
PYTHON_REQ_USE="xml(+)"
inherit distutils-r1
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/adrientetar/${PN}.git"
else
	inherit vcs-snapshot
	MY_PV="d5dd524"
	[[ -n ${PV%%*_p*} ]] && MY_PV="v${PV}"
	SRC_URI="
		mirror://githubcl/adrientetar/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="A set of Qt objects for use in defcon applications"
HOMEPAGE="https://github.com/adrientetar/${PN}"

LICENSE="|| ( GPL-3 LGPL-3 )"
SLOT="0"
IUSE="test"

RDEPEND="
	>=dev-python/PyQt5-5.7[widgets,${PYTHON_USEDEP}]
	>=dev-python/fonttools-3.8.0[${PYTHON_USEDEP}]
	dev-python/ufoLib[${PYTHON_USEDEP}]
	dev-python/defcon[${PYTHON_USEDEP}]
"
DEPEND="
	${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( dev-python/pytest-runner[${PYTHON_USEDEP}] )
"

python_prepare_all() {
	# no egg-info for PyQt5
	sed -e '/\<pyqt5\>/d' -i setup.py
	distutils-r1_python_prepare_all
}

python_test() {
	esetup.py test
}
