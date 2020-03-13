# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7} )
PYTHON_REQ_USE="xml(+)"

inherit eutils distutils-r1
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/${PN}/${PN}.git"
else
	if [[ -z ${PV%%*_p*} ]]; then
		inherit vcs-snapshot
		MY_PV="66d847e"
	fi
	MY_PV="${PV}"
	SRC_URI="
		mirror://githubcl/${PN}/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="Library for manipulating TrueType, OpenType, AFM and Type1 fonts"
HOMEPAGE="https://github.com/${PN}/${PN}"

LICENSE="BSD"
SLOT="0"
IUSE="brotli gtk qt5 test +ufo unicode zopfli"
DOCS=( {README,NEWS}.rst )
PATCHES=(
	"${FILESDIR}"/${PN}-xattr.diff
)

# README.rst: Optional Requirements
RDEPEND="
	>=dev-python/lxml-4.4.1[${PYTHON_USEDEP}]
	brotli? ( app-arch/brotli[python,${PYTHON_USEDEP}] )
	zopfli? ( dev-python/py-zopfli[${PYTHON_USEDEP}] )
	ufo? (
		>=dev-python/fs-2.4.11[${PYTHON_USEDEP}]
	)
	unicode? (
		dev-python/unicodedata2[${PYTHON_USEDEP}]
	)
	qt5? ( dev-python/PyQt5[${PYTHON_USEDEP}] )
	gtk? ( dev-python/pygobject:3[${PYTHON_USEDEP}] )
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	test? (
		sci-libs/scipy[${PYTHON_USEDEP}]
	)
"
distutils_enable_tests pytest

pkg_postinst() {
	optfeature \
		"finding wrong contour/component order between different masters" \
		sci-libs/scipy
	optfeature \
		"visualizing DesignSpaceDocument and resulting VariationModel" \
		dev-python/matplotlib
	optfeature "symbolic font statistics analysis" dev-python/sympy
	optfeature "drawing glyphs as PNG images" dev-python/reportlab
}
