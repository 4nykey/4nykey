# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_AN="antlr4-cpp-runtime-4.9.3-source.zip"
SRC_URI="
	https://www.antlr.org/download/${MY_AN}
"
PYTHON_COMPAT=( python3_{10..12} )
DISTUTILS_USE_PEP517=setuptools
DISTUTILS_ARGS=(
	-DCMAKE_VERBOSE_MAKEFILE=ON
	-DANTLR4_ZIP_REPOSITORY="${DISTDIR}/${MY_AN}"
)
inherit distutils-r1
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/adobe-type-tools/${PN}.git"
else
	MY_PV="21d8b26"
	[[ -n ${PV%%*_*} ]] && MY_PV="${PV}"
	SRC_URI+="
		mirror://githubcl/adobe-type-tools/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64"
	S="${WORKDIR}/${PN}-${MY_PV}"
fi

DESCRIPTION="Adobe Font Development Kit for OpenType"
HOMEPAGE="https://adobe-type-tools.github.io/afdko"

LICENSE="Apache-2.0"
SLOT="0"
IUSE="test"

RDEPEND="
	>=dev-python/booleanOperations-0.9[${PYTHON_USEDEP}]
	>=dev-python/defcon-0.10.3[${PYTHON_USEDEP}]
	>=dev-python/fontMath-0.9.3[${PYTHON_USEDEP}]
	dev-python/fontPens[${PYTHON_USEDEP}]
	>=dev-python/fonttools-4.43[ufo(+),unicode(-),woff(-),${PYTHON_USEDEP}]
	>=dev-python/tqdm-4.66.1[${PYTHON_USEDEP}]
	>=dev-python/ufoNormalizer-0.6.1[${PYTHON_USEDEP}]
	>=dev-python/ufoProcessor-1.9[${PYTHON_USEDEP}]
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	dev-python/setuptools-scm[${PYTHON_USEDEP}]
	dev-python/scikit-build[${PYTHON_USEDEP}]
"
DOCS=( {README,NEWS}.md docs )
PATCHES=( "${FILESDIR}"/setup.diff )
distutils_enable_tests pytest

python_prepare_all() {
	local _v="${PV/_pre/.dev}"
	[[ -n ${PV%%*9999} ]] && export SETUPTOOLS_SCM_PRETEND_VERSION="${_v/_p/.post}"

	rm -f docs/*.{yml,plist}
	distutils-r1_python_prepare_all
}
