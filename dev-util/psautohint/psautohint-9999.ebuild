# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )
DISTUTILS_IN_SOURCE_BUILD=1

MY_TD="psautohint-testdata-1e4c506"
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/adobe-type-tools/${PN}.git"
else
	MY_PV="c771321"
	[[ -n ${PV%%*_*} ]] && MY_PV="v${PV}"
	SRC_URI="
		mirror://githubcl/adobe-type-tools/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
		test? (
			mirror://githubcl/adobe-type-tools/${MY_TD%-*}/tar.gz/${MY_TD##*-}
			-> ${MY_TD}.tar.gz
		)
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/${PN}-${MY_PV#v}"
fi
EMESON_SOURCE="${S}/libpsautohint"
inherit meson distutils-r1

DESCRIPTION="A standalone version of AFDKO autohinter"
HOMEPAGE="https://github.com/adobe-type-tools/${PN}"

LICENSE="Apache-2.0"
SLOT="0"
IUSE="test"

RDEPEND="
	>=dev-python/fonttools-4.29[ufo(+),${PYTHON_USEDEP}]
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	test? (
		dev-python/coverage[${PYTHON_USEDEP}]
	)
"
EPYTEST_DESELECT=(
	tests/integration/test_hint.py::test_hashmap_old_version
	"tests/integration/test_mmhint.py::test_vfotf[tests/integration/data/vf_tests/CJKSparseVar.subset.hinted.otf]"
)
distutils_enable_tests pytest

pkg_setup() {
	if [[ -n ${PV%%*9999} ]]; then
		local _v=$(ver_cut 4)
		_v="$(ver_cut 1-3)${_v:0:1}$(ver_cut 5)"
		export SETUPTOOLS_SCM_PRETEND_VERSION="${_v/p/.post}"
	fi
	MESON_BUILD_DIR="${S%/*}/${P}-build"
}

python_prepare_all() {
	local PATCHES=(
		"${FILESDIR}"/${PN}-bininpath.diff
	)
	sed \
		-e "s:self.distribution.has_\(executabl\|c_librari\)es():False:" \
		-e "/\(executabl\|librari\)es=\(executabl\|librari\)es,/d" \
		-e "/lib': Custom\(InstallL\|BuildCl\)ib/d" \
		-e "/build_exe': build_exe,/d" \
		-i setup.py
	sed -e '/-Werror/d' -i "${EMESON_SOURCE}"/meson.build
	sed -e '/-n auto/d' -i pytest.ini
	use test && mv ../${MY_TD}/* tests/integration/data/
	distutils-r1_python_prepare_all
}

src_configure() {
	BUILD_DIR="${MESON_BUILD_DIR}" \
		meson_src_configure
	distutils-r1_src_configure
}

src_compile() {
	BUILD_DIR="${MESON_BUILD_DIR}" \
		meson_src_compile
	distutils-r1_src_compile
}

python_compile() {
	esetup.py build_py build_ext \
		--library-dirs "${MESON_BUILD_DIR}"
}

src_install() {
	BUILD_DIR="${MESON_BUILD_DIR}" \
		meson_src_install
	distutils-r1_src_install
}

python_test() {
	local -x \
		PATH="${BUILD_DIR}/test/scripts:${MESON_BUILD_DIR}l:${PATH}" \
		LD_LIBRARY_PATH="${MESON_BUILD_DIR}"
	distutils_install_for_testing
	epytest
}
