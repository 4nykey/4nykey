# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..13} )
DISTUTILS_USE_PEP517=setuptools
DISTUTILS_SINGLE_IMPL=1

inherit distutils-r1
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/${PN}/${PN}.git"
else
	MY_PV="4ecc41c"
	[[ -n ${PV%%*_p*} ]] && MY_PV="${PV}"
	SRC_URI="
		mirror://githubcl/${PN}/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64"
	S="${WORKDIR}/${PN}-${MY_PV}"
fi

DESCRIPTION="Tool for transforming reStructuredText to PDF using ReportLab"
HOMEPAGE="https://rst2pdf.org"

LICENSE="MIT"
SLOT="0"
IUSE="aafigure html matplotlib plantuml svg"
REQUIRED_USE="test? ( aafigure plantuml svg )"

DEPEND="
	$(python_gen_cond_dep '
		dev-python/docutils[${PYTHON_USEDEP}]
		dev-python/importlib-metadata[${PYTHON_USEDEP}]
		dev-python/jinja2[${PYTHON_USEDEP}]
		dev-python/packaging[${PYTHON_USEDEP}]
		dev-python/pygments[${PYTHON_USEDEP}]
		dev-python/pyyaml[${PYTHON_USEDEP}]
		dev-python/reportlab[${PYTHON_USEDEP}]
		dev-python/smartypants[${PYTHON_USEDEP}]
		aafigure? ( dev-python/aafigure[${PYTHON_USEDEP}] )
		matplotlib? ( dev-python/matplotlib[${PYTHON_USEDEP}] )
		svg? ( dev-python/svglib[${PYTHON_USEDEP}] )
		html? ( dev-python/xhtml2pdf[${PYTHON_USEDEP}] )
	')
	plantuml? ( media-gfx/plantuml )
"
RDEPEND="
	${DEPEND}
"
BDEPEND="
	$(python_gen_cond_dep '
		test? (
			dev-python/PyMuPDF[${PYTHON_USEDEP}]
		)
	')
"
PATCHES=( "${FILESDIR}"/setuptools.diff )
distutils_enable_tests pytest

src_prepare() {
	rm -rf snap tests/input/sphinx-*
	local _v="${PV/_pre/.dev}"
	[[ -n ${PV%%*9999} ]] && export SETUPTOOLS_SCM_PRETEND_VERSION="${_v/_p/.post}"
	default
}
