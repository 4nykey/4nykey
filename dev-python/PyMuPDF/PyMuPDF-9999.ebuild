# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..13} )
DISTUTILS_USE_PEP517=setuptools
DISTUTILS_EXT=1
inherit toolchain-funcs distutils-r1
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/pymupdf/${PN}.git"
else
	MY_PV="444b5eb"
	[[ -n ${PV%%*_p*} ]] && MY_PV="${PV}"
	SRC_URI="
		mirror://githubcl/pymupdf/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64"
	S="${WORKDIR}/${PN}-${MY_PV}"
fi

DESCRIPTION="A Python library for manipulation of PDF documents"
HOMEPAGE="https://pymupdf.readthedocs.io"

LICENSE="AGPL-3"
SLOT="0"

DEPEND="
	>=dev-python/mupdf-1.26:=[${PYTHON_USEDEP}]
"
RDEPEND="
	${DEPEND}
"
BDEPEND="
	dev-lang/swig
"
distutils_enable_tests pytest

python_prepare_all() {
	rm -f pyproject.toml
	distutils-r1_python_prepare_all
}

python_compile() {
	local _i=( $($(tc-getPKG_CONFIG) mupdf --cflags-only-I) )
	PYMUPDF_SETUP_FLAVOUR='p' \
	PYMUPDF_SETUP_MUPDF_BUILD= \
	PYMUPDF_SETUP_MUPDF_THIRD=0 \
	PYMUPDF_SETUP_MUPDF_REBUILD=0 \
	PYMUPDF_INCLUDES="$(printf '%s:' ${_i[@]//-I})${EPREFIX}/usr/include" \
	PYMUPDF_MUPDF_LIB="${EPREFIX}/usr" \
		distutils-r1_python_compile
}
