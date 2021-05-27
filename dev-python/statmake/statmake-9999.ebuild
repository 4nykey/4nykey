# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )
DISTUTILS_USE_SETUPTOOLS=pyproject.toml
inherit distutils-r1
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/daltonmaag/${PN}.git"
else
	MY_PV="77e29d6"
	[[ -n ${PV%%*_p*} ]] && MY_PV="v${PV}"
	SRC_URI="
		mirror://githubcl/daltonmaag/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/${PN}-${MY_PV#v}"
fi

DESCRIPTION="Generate STAT tables for variable fonts from .stylespace files"
HOMEPAGE="https://github.com/daltonmaag/${PN}"

LICENSE="MIT"
SLOT="0"
IUSE="test"

RDEPEND="
	dev-python/fonttools[ufo(-),${PYTHON_USEDEP}]
	dev-python/cattrs[${PYTHON_USEDEP}]
"
DEPEND="
	${RDEPEND}
"
distutils_enable_tests pytest

python_install() {
	distutils-r1_python_install \
		--skip-build
	python_domodule src/${PN}
}

python_test() {
	local -x PYTHONPATH="${S}/src:${PYTHONPATH}"
	pytest -vv || die "Tests fail with ${EPYTHON}"
}
