# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{12..14} )
DISTUTILS_USE_PEP517=standalone
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
	dev-python/mupdf:=[${PYTHON_USEDEP}]
	dev-python/pymupdf-fonts[${PYTHON_USEDEP}]
	dev-python/pipcl[${PYTHON_USEDEP}]
"
RDEPEND="
	${DEPEND}
"
BDEPEND="
	dev-lang/swig
	test? (
		dev-python/flake8[${PYTHON_USEDEP}]
		dev-python/mypy[${PYTHON_USEDEP}]
		dev-python/pylint[${PYTHON_USEDEP}]
	)
"
PATCHES=( "${FILESDIR}"/tests.diff )
EPYTEST_DESELECT=(
	tests/test_4505.py::test_4505
	tests/test_widgets.py::test_2391
	tests/test_widgets.py::test_3216
	tests/test_widgets.py::test_3950
	tests/test_widgets.py::test_4004
	tests/test_widgets.py::test_4055
	tests/test_widgets.py::test_4965
	tests/test_widgets.py::test_checkbox
	tests/test_widgets.py::test_interfield_calculation
	tests/test_widgets.py::test_text
)
EPYTEST_DESELECT+=(
	tests/test_codespell.py::test_codespell
	tests/test_font.py::test_4457
	tests/test_general.py::test_4533
	tests/test_general.py::test_4702
	tests/test_general.py::test_open2
	tests/test_memory.py::test_4751
	tests/test_pixmap.py::test_3050
	tests/test_pixmap.py::test_3058
	tests/test_pixmap.py::test_3854
	tests/test_pixmap.py::test_4445
	tests/test_pixmap.py::test_4445
	tests/test_pixmap.py::test_color_count
	tests/test_pylint.py::test_pylint
	tests/test_tesseract.py
	tests/test_textbox.py::test_textbox3
	tests/test_textextract.py::test_4180
)
distutils_enable_tests pytest

python_compile() {
	local _i=( $($(tc-getPKG_CONFIG) mupdf --cflags-only-I) )
	PYMUPDF_SETUP_FLAVOUR='p' \
	PYMUPDF_SETUP_MUPDF_BUILD= \
	PYMUPDF_SETUP_MUPDF_THIRD=0 \
	PYMUPDF_SETUP_MUPDF_REBUILD=0 \
	PYMUPDF_INCLUDES="$(printf '%s:' ${_i[@]//-I})${EPREFIX}/usr/include" \
	PYMUPDF_MUPDF_LIB="${EPREFIX}/usr" \
	LD="${CXX}" \
		distutils-r1_python_compile
}
