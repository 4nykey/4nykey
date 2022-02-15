# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..10} )
inherit distutils-r1
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/daltonmaag/${PN}.git"
else
	MY_PV="v${PV}"
	[[ -z ${PV%%*_p*} ]] && MY_PV="d2ddba0"
	SRC_URI="
		mirror://githubcl/daltonmaag/${PN}/tar.gz/${MY_PV}
		-> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/${PN}-${MY_PV#v}"
fi

DESCRIPTION="A library for VTT hinting"
HOMEPAGE="https://github.com/daltonmaag/${PN}"

LICENSE="MIT"
SLOT="0"
IUSE=""

RDEPEND="
	>=dev-python/fonttools-4.10.2[${PYTHON_USEDEP}]
	>=dev-python/pyparsing-2.4.7[${PYTHON_USEDEP}]
	>=dev-python/ufoLib2-0.7.1[${PYTHON_USEDEP}]
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	dev-python/setuptools_scm[${PYTHON_USEDEP}]
	test? (
		dev-python/ufo2ft[${PYTHON_USEDEP}]
		dev-python/black[${PYTHON_USEDEP}]
	)
"
distutils_enable_tests pytest

pkg_setup() {
	[[ -n ${PV%%*9999} ]] && export SETUPTOOLS_SCM_PRETEND_VERSION="${PV%_*}"
}

python_prepare_all() {
	sed -e '/\<wheel\>/d' -i setup.cfg
	distutils-r1_python_prepare_all
}
