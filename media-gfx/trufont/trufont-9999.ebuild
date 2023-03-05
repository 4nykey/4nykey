# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..11} )
PYTHON_REQ_USE="xml(+)"
DISTUTILS_SINGLE_IMPL=1
VIRTUALX_REQUIRED="test"
inherit distutils-r1 virtualx
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/${PN}/${PN}.git"
else
	MY_PV="97a89d0"
	[[ -n ${PV%%*_p*} ]] && MY_PV="${PV}"
	SRC_URI="
		mirror://githubcl/${PN}/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/${PN}-${MY_PV}"
fi

DESCRIPTION="An ufo3 font editor"
HOMEPAGE="https://trufont.github.io/"

LICENSE="MPL-2.0"
SLOT="0"
IUSE=""

RDEPEND="
	$(python_gen_cond_dep '
		>=dev-python/fonttools-4.15[ufo(-),unicode(-),woff(-),${PYTHON_USEDEP}]
		>=dev-python/booleanOperations-0.9[${PYTHON_USEDEP}]
		>=dev-python/defcon-0.7.2[${PYTHON_USEDEP}]
		>=dev-python/hsluv-5[${PYTHON_USEDEP}]
		dev-python/PyQt5[${PYTHON_USEDEP}]
		>=dev-python/extractor-0.3[${PYTHON_USEDEP}]
		>=dev-python/ufo2ft-2.16[${PYTHON_USEDEP}]
	')
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	$(python_gen_cond_dep '
		dev-python/setuptools-scm[${PYTHON_USEDEP}]
	')
"
distutils_enable_tests pytest

python_prepare_all() {
	[[ -n ${PV%%*9999} ]] && export SETUPTOOLS_SCM_PRETEND_VERSION="${PV%_*}"
	sed \
		-e 's:\<wheel\>::' \
		-i setup.cfg
	distutils-r1_python_prepare_all
}

python_test() {
	virtx epytest
}
