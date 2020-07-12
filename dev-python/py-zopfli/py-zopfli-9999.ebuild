# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8} )
inherit distutils-r1
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/obp/${PN}.git"
else
	MY_PV="b3ccd1b"
	[[ -n ${PV%%*_p*} ]] && MY_PV="v${PV}"
	MY_ZP="zopfli-bd64b2f"
	SRC_URI="
		mirror://githubcl/obp/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
		mirror://githubcl/google/${MY_ZP%-*}/tar.gz/${MY_ZP##*-} -> ${MY_ZP}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/${PN}-${MY_PV#v}"
fi

DESCRIPTION="Python bindings for zopfli"
HOMEPAGE="https://github.com/obp/${PN}"

LICENSE="Apache-2.0"
SLOT="0"
IUSE=""

RDEPEND=""
DEPEND="
	${RDEPEND}
"
distutils_enable_tests setup.py

python_prepare_all() {
	[[ -n ${PV%%*9999} ]] && mv "${WORKDIR}"/${MY_ZP}/src "${S}"/zopfli
	distutils-r1_python_prepare_all
}
