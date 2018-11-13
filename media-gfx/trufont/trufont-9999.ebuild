# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_{4,5,6,7} )
PYTHON_REQ_USE="xml(+)"
inherit distutils-r1 virtualx
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/${PN}/${PN}.git"
	EGIT_BRANCH="wx"
else
	inherit vcs-snapshot
	MY_PV="0c8b6d7"
	[[ -n ${PV%%*_p*} ]] && MY_PV="${PV}"
	SRC_URI="
		mirror://githubcl/${PN}/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="An ufo3 font editor"
HOMEPAGE="https://trufont.github.io/"

LICENSE="MPL-2.0"
SLOT="0"
IUSE="test"

RDEPEND="
	dev-python/tfont[${PYTHON_USEDEP}]
	dev-python/uharfbuzz[${PYTHON_USEDEP}]
	dev-python/fonttools[${PYTHON_USEDEP}]
	dev-python/skia-pathops[${PYTHON_USEDEP}]
	dev-python/wxpython:4.0[${PYTHON_USEDEP}]
"
DEPEND="
	${RDEPEND}
	dev-python/setuptools_scm[${PYTHON_USEDEP}]
	test? (
		dev-python/pytest[${PYTHON_USEDEP}]
	)
"

python_prepare_all() {
	[[ -n ${PV%%*9999} ]] && export SETUPTOOLS_SCM_PRETEND_VERSION="${PV%_*}"
	sed -e 's:\<git\>:true:' -i src/trufont/windows/fontWindow.py
	distutils-r1_python_prepare_all
}
