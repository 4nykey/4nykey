# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{10..11} )
inherit distutils-r1
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/googlei18n/${PN}.git"
else
	[[ -z ${PV%%*_*} ]] && inherit vcs-snapshot
	MY_PV="1ef915d"
	if [[ -n ${PV%%*_p*} ]]; then
		MY_PV=$(ver_cut 4)
		MY_PV="v$(ver_cut 1-3)${MY_PV:0:1}$(ver_cut 5)"
	fi
	SRC_URI="
		mirror://githubcl/googlei18n/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64"
fi

DESCRIPTION="A wrapper for several Python libraries to compile fonts from sources"
HOMEPAGE="https://github.com/googlei18n/${PN}"

LICENSE="Apache-2.0"
SLOT="0"
IUSE=""

RDEPEND="
	>=dev-python/fonttools-4.40[skia(-),ufo(-),unicode(-),${PYTHON_USEDEP}]
	>=dev-python/glyphsLib-6.2.1[${PYTHON_USEDEP}]
	>=dev-python/ufo2ft-2.32[cffsubr(+),${PYTHON_USEDEP}]
	>=dev-python/MutatorMath-3.0.1[${PYTHON_USEDEP}]
	>=dev-python/fontMath-0.9.3[${PYTHON_USEDEP}]
	>=dev-python/defcon-0.10.2[${PYTHON_USEDEP}]
	>=dev-python/booleanOperations-0.9[${PYTHON_USEDEP}]
	dev-python/skia-pathops[${PYTHON_USEDEP}]
	>=dev-python/ufoLib2-0.14[${PYTHON_USEDEP}]
	>=dev-python/attrs-22.1[${PYTHON_USEDEP}]
	>=dev-python/ttfautohint-py-0.5.1[${PYTHON_USEDEP}]
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	dev-python/setuptools-scm[${PYTHON_USEDEP}]
	test? (
		media-gfx/fontdiff
		dev-python/mock[${PYTHON_USEDEP}]
	)
"
PATCHES=(
	"${FILESDIR}"/defaults.diff
	"${FILESDIR}"/instance_dir.diff
)
distutils_enable_tests pytest

pkg_setup() {
	[[ -n ${PV%%*9999} ]] && export SETUPTOOLS_SCM_PRETEND_VERSION="${PV%_*}"
}
