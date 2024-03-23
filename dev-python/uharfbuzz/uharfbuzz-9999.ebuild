# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..11} )
DISTUTILS_USE_PEP517=setuptools
DISTUTILS_EXT=1
inherit distutils-r1
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/harfbuzz/${PN}.git"
else
	MY_PV="3e8a1e2"
	[[ -n ${PV%%*_p*} ]] && MY_PV="v${PV}"
	MY_HB="harfbuzz-8.3.1"
	SRC_URI="
		mirror://githubcl/harfbuzz/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
		https://github.com/harfbuzz/harfbuzz/releases/download/${MY_HB#*-}/${MY_HB}.tar.xz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64"
fi

DESCRIPTION="Streamlined Cython bindings for the HarfBuzz shaping engine"
HOMEPAGE="https://github.com/harfbuzz/${PN}"

LICENSE="Apache-2.0"
SLOT="0"
IUSE=""

RDEPEND="
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	dev-python/setuptools-scm[${PYTHON_USEDEP}]
	dev-python/cython[${PYTHON_USEDEP}]
"
distutils_enable_tests pytest

python_prepare_all() {
	distutils-r1_python_prepare_all
	[[ -z ${PV%%*9999} ]] && return
	export SETUPTOOLS_SCM_PRETEND_VERSION="${PV%_*}"
	mv "${WORKDIR}"/${MY_HB}/* harfbuzz
}

python_install() {
	distutils-r1_python_install
	python_optimize "${ED}"/$(python_get_sitedir)/${PN}
}
