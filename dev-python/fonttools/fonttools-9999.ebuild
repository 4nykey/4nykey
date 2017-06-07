# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{4,5,6} )
PYTHON_REQ_USE="xml(+)"

inherit distutils-r1
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/${PN}/${PN}.git"
else
	inherit vcs-snapshot
	MY_PV="66d847e"
	[[ -n ${PV%%*_p*} ]] && MY_PV="${PV}"
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
IUSE="brotli gtk qt5 test zopfli"
DOCS=( {README,NEWS}.rst )
PATCHES=(
	"${FILESDIR}"/${PN}-glyphclass.diff
)

# Lib/fonttools.egg-info/PKG-INFO: Optional Requirements
RDEPEND="
	brotli? ( app-arch/brotli[${PYTHON_USEDEP}] )
	zopfli? ( dev-python/py-zopfli[${PYTHON_USEDEP}] )
	dev-python/unicodedata2[${PYTHON_USEDEP}]
	sci-libs/scipy[${PYTHON_USEDEP}]
	dev-python/munkres[${PYTHON_USEDEP}]
	dev-python/sympy[${PYTHON_USEDEP}]
	qt5? ( dev-python/PyQt5[${PYTHON_USEDEP}] )
	dev-python/reportlab[${PYTHON_USEDEP}]
	gtk? ( dev-python/pygobject:3[${PYTHON_USEDEP}] )
"
DEPEND="
	${RDEPEND}
	test? ( dev-python/pytest-runner[${PYTHON_USEDEP}] )
"

python_test() {
	esetup.py test
}
