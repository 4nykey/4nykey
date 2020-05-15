# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7} )
PYTHON_REQ_USE="xml(+)"
VIRTUALX_REQUIRED="test"
inherit distutils-r1 virtualx
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/${PN}/${PN}.git"
else
	MY_PV="${PV}"
	if [[ -z ${PV%%*_p*} ]]; then
		inherit vcs-snapshot
		MY_PV="cae4e85"
	fi
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
IUSE=""

RDEPEND="
	>=dev-python/fonttools-4.9[ufo(-),unicode(-),${PYTHON_USEDEP}]
	>=dev-python/booleanOperations-0.9[${PYTHON_USEDEP}]
	>=app-arch/brotli-1.0.7[python,${PYTHON_USEDEP}]
	>=dev-python/defcon-0.6[${PYTHON_USEDEP}]
	>=dev-python/hsluv-5[${PYTHON_USEDEP}]
	dev-python/PyQt5[${PYTHON_USEDEP}]
	>=dev-python/pytz-2020.1[${PYTHON_USEDEP}]
	>=dev-python/extractor-0.3[${PYTHON_USEDEP}]
	>=dev-python/ufo2ft-2.13[${PYTHON_USEDEP}]
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	dev-python/setuptools_scm[${PYTHON_USEDEP}]
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
	virtx pytest -vv || die "Tests fail with ${EPYTHON}"
}
