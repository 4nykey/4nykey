# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{4,5} )
inherit distutils-r1
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/anthrotype/${PN}.git"
else
	inherit vcs-snapshot
	MY_PV="b3ccd1b"
	[[ -n ${PV%%*_p*} ]] && MY_PV="${PV}"
	MY_ZP="zopfli-6818a08"
	SRC_URI="
		mirror://githubcl/anthrotype/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
		mirror://githubcl/google/${MY_ZP%-*}/tar.gz/${MY_ZP##*-} -> ${MY_ZP}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="Python bindings for zopfli"
HOMEPAGE="https://github.com/anthrotype/${PN}"

LICENSE="Apache-2.0"
SLOT="0"
IUSE=""

RDEPEND=""
DEPEND="
	${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
"

src_prepare() {
	[[ -n ${PV%%*9999} ]] && mv "${WORKDIR}"/${MY_ZP}/src "${S}"/${MY_ZP%-*}
	distutils-r1_src_prepare
}

python_test() {
	esetup.py test || die
}
