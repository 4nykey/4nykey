# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )
CMAKE_IN_SOURCE_BUILD=1
inherit cmake distutils-r1
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/adobe-type-tools/${PN}.git"
else
	MY_PV="aed94ea"
	[[ -n ${PV%%*_*} ]] && MY_PV="${PV}"
	SRC_URI="
		mirror://githubcl/adobe-type-tools/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/${PN}-${MY_PV}"
fi

DESCRIPTION="Adobe Font Development Kit for OpenType"
HOMEPAGE="https://adobe-type-tools.github.io/afdko"

LICENSE="Apache-2.0"
SLOT="0"
IUSE="test"

RDEPEND="
	dev-cpp/antlr-cpp:4=
	>=dev-python/booleanOperations-0.9[${PYTHON_USEDEP}]
	>=dev-python/defcon-0.9[${PYTHON_USEDEP}]
	>=dev-python/fontMath-0.8.1[${PYTHON_USEDEP}]
	dev-python/fontPens[${PYTHON_USEDEP}]
	>=dev-python/fonttools-4.25.2[ufo(-),unicode(-),${PYTHON_USEDEP}]
	>=dev-util/psautohint-2.3.1[${PYTHON_USEDEP}]
	>=dev-python/tqdm-4.62.2[${PYTHON_USEDEP}]
	>=dev-python/ufoNormalizer-0.6[${PYTHON_USEDEP}]
	>=dev-python/ufoProcessor-1.9[${PYTHON_USEDEP}]
"
DEPEND="
	${RDEPEND}
"
DOCS=( {README,NEWS}.md docs )
distutils_enable_tests pytest

python_prepare_all() {
	local _v="${PV/_pre/.dev}"
	[[ -n ${PV%%*9999} ]] && export SETUPTOOLS_SCM_PRETEND_VERSION="${_v/_p/.post}"

	local _p=(
		"${FILESDIR}"/system-antlr.diff
		"${FILESDIR}"/setup.diff
	)
	eapply "${_p[@]}"

	rm -f docs/*.{yml,plist}
	cmake_src_prepare
	distutils-r1_python_prepare_all
}

python_configure_all() {
	local mycmakeargs=(
		-DANTLR4_INCLUDE_DIRS="${EPREFIX}/usr/include/antlr4-runtime"
	)
	cmake_src_configure
}

python_compile_all() {
	cmake_src_compile
}

python_test() {
	local -x \
		PYTHONPATH="${S}/python:${PYTHONPATH}" \
		PATH="${S}/bin:${BUILD_DIR}/test/scripts:${PATH}"
	distutils_install_for_testing
	pytest -v || die
}
