# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/${PN}/${PN}.git"
else
	MY_PV="3eef378"
	[[ -n ${PV%%*_p*} ]] && MY_PV="v${PV}"
	SRC_URI="
		mirror://githubcl/${PN}/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64"
	S="${WORKDIR}/${PN}-${MY_PV#v}"
fi

DESCRIPTION="Tool for transforming reStructuredText to PDF using ReportLab"
HOMEPAGE="https://xhtml2pdf.readthedocs.io"

LICENSE="Apache-2.0"
SLOT="0"
IUSE="test"

DEPEND="
	dev-python/python-arabic-reshaper[${PYTHON_USEDEP}]
	dev-python/html5lib[${PYTHON_USEDEP}]
	dev-python/pillow[${PYTHON_USEDEP}]
	dev-python/pypdf[${PYTHON_USEDEP}]
	dev-python/python-bidi[${PYTHON_USEDEP}]
	dev-python/reportlab[${PYTHON_USEDEP}]
	dev-python/svglib[${PYTHON_USEDEP}]
	dev-python/pyHanko[${PYTHON_USEDEP}]
"
RDEPEND="
	${DEPEND}
"
distutils_enable_tests pytest

python_install() {
	distutils-r1_python_install
	python_optimize
}
