# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{10..11} )
inherit distutils-r1
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/googlei18n/${PN}.git"
else
	MY_PV="2886fa4"
	if [[ -n ${PV%%*_p*} ]]; then
		MY_PV=$(ver_cut 4)
		MY_PV="v$(ver_cut 1-3)${MY_PV:0:1}$(ver_cut 5)"
	fi
	SRC_URI="
		mirror://githubcl/googlei18n/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64"
	S="${WORKDIR}/${PN}-${MY_PV#v}"
fi

DESCRIPTION="A bridge from UFOs to FontTool objects"
HOMEPAGE="https://github.com/googlei18n/${PN}"

LICENSE="MIT"
SLOT="0"
IUSE="test"
PATCHES=( "${FILESDIR}"/cu2qu.diff )

RDEPEND="
	>=dev-python/fonttools-4.39.2[ufo(-),${PYTHON_USEDEP}]
	>=dev-python/defcon-0.10.2[${PYTHON_USEDEP}]
	>=dev-python/compreffor-0.5.3[${PYTHON_USEDEP}]
	>=dev-python/booleanOperations-0.9[${PYTHON_USEDEP}]
	>=dev-python/cffsubr-0.2.9[${PYTHON_USEDEP}]
	>=dev-python/skia-pathops-0.7.4[${PYTHON_USEDEP}]
	>=dev-python/ufoLib2-0.14[${PYTHON_USEDEP}]
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	dev-python/setuptools-scm[${PYTHON_USEDEP}]
"
distutils_enable_tests pytest

pkg_setup() {
	[[ -n ${PV%%*9999} ]] && export SETUPTOOLS_SCM_PRETEND_VERSION="${PV%_*}"
}
