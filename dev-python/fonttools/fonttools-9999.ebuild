# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{4,5} )
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
IUSE="brotli test zopfli"
DOCS=( {README,NEWS}.rst )

RDEPEND="
	>=dev-python/numpy-1.0.2[${PYTHON_USEDEP}]
	brotli? ( app-arch/brotli[${PYTHON_USEDEP}] )
	zopfli? ( dev-python/py-zopfli[${PYTHON_USEDEP}] )
"
DEPEND="
	${RDEPEND}
	test? ( dev-python/pytest-runner[${PYTHON_USEDEP}] )
"

python_test() {
	esetup.py test || die
}
