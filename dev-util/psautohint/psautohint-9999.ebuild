# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8} )
DISTUTILS_IN_SOURCE_BUILD=1
EMESON_SOURCE="${S}/libpsautohint"
inherit meson distutils-r1

if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/adobe-type-tools/${PN}.git"
else
	MY_PV="0b7af01"
	[[ -n ${PV%%*_*} ]] && MY_PV="v${PV}"
	MY_TD="psautohint-testdata-b12b42f"
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

DESCRIPTION="A standalone version of AFDKO autohinter"
HOMEPAGE="https://github.com/adobe-type-tools/${PN}"

LICENSE="Apache-2.0"
SLOT="0"
IUSE="test"

RDEPEND="
	>=dev-python/fonttools-4.16.1[ufo,${PYTHON_USEDEP}]
	>=dev-python/lxml-4.5.2[${PYTHON_USEDEP}]
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	test? (
		dev-python/coverage[${PYTHON_USEDEP}]
	)
"
distutils_enable_tests pytest

pkg_setup() {
	if [[ -n ${PV%%*9999} ]]; then
		local _v=$(ver_cut 4)
		_v="$(ver_cut 1-3)${_v:0:1}$(ver_cut 5)"
		export SETUPTOOLS_SCM_PRETEND_VERSION="${_v/p/.post}"
	fi
	MESON_BUILD_DIR="${WORKDIR}/${P}-build"
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
	[[ -d "${WORKDIR}"/${MY_TD} ]] && \
		mv "${WORKDIR}"/${MY_TD}/* "${S}"/tests/integration/data/
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
	local _t="${BUILD_DIR}/test"
	local -x \
		PYTHONPATH="${_t}/lib/python:${PYTHONPATH}" \
		PATH="${_t}/scripts:${MESON_BUILD_DIR}l:${PATH}" \
		LD_LIBRARY_PATH="${MESON_BUILD_DIR}"
	mkdir -p "${_t}/lib/python"
	distutils_install_for_testing
	pytest -v || die
}
