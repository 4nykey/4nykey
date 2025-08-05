# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..13} )
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/googlefonts/${PN}.git"
else
	MY_PV="2886fa4"
	if [[ -n ${PV%%*_p*} ]]; then
		MY_PV=$(ver_cut 4)
		MY_PV="v$(ver_cut 1-3)${MY_PV:0:1}$(ver_cut 5)"
	fi
	SRC_URI="
		mirror://githubcl/googlefonts/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64"
	S="${WORKDIR}/${PN}-${MY_PV#v}"
fi

DESCRIPTION="A bridge from UFOs to FontTool objects"
HOMEPAGE="https://github.com/googlefonts/${PN}"

LICENSE="MIT"
SLOT="0"
IUSE="test"

RDEPEND="
	>=dev-python/fonttools-4.58.5[ufo(-),${PYTHON_USEDEP}]
	>=dev-python/defcon-0.10.3[${PYTHON_USEDEP}]
	>=dev-python/compreffor-0.5.6[${PYTHON_USEDEP}]
	>=dev-python/booleanOperations-0.9[${PYTHON_USEDEP}]
	>=dev-python/cffsubr-0.3[${PYTHON_USEDEP}]
	>=dev-python/skia-pathops-0.8[${PYTHON_USEDEP}]
	>=dev-python/fontMath-0.9.4[${PYTHON_USEDEP}]
	>=dev-python/ufoLib2-0.17.1[${PYTHON_USEDEP}]
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	test? (
		dev-python/syrupy[${PYTHON_USEDEP}]
	)
"
distutils_enable_tests pytest

pkg_setup() {
	[[ -n ${PV%%*9999} ]] && export SETUPTOOLS_SCM_PRETEND_VERSION="${PV%_*}"
}
