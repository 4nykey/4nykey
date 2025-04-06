# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..13} )
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/python/${PN}.git"
else
	MY_PV="1f4d3f1"
	[[ -n ${PV%%*_p*} ]] && MY_PV="v${PV}"
	SRC_URI="
		mirror://githubcl/python/${PN}/tar.gz/${MY_PV}
		-> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64"
	S="${WORKDIR}/${PN}-${MY_PV#v}"
fi

DESCRIPTION="Backport of the importlib.resources module"
HOMEPAGE="https://github.com/python/${PN}"

LICENSE="Apache-2.0"
SLOT="0"

RDEPEND="
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	test? (
		dev-python/jaraco-test[${PYTHON_USEDEP}]
	)
"
distutils_enable_tests pytest

python_prepare_all() {
	[[ -n ${PV%%*9999} ]] && export SETUPTOOLS_SCM_PRETEND_VERSION="${PV%_*}"
	distutils-r1_python_prepare_all
}
