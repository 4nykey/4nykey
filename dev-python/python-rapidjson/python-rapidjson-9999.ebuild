# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/${PN}/${PN}.git"
	EGIT_SUBMODULES=( )
else
	MY_PV="39a9c61"
	[[ -n ${PV%%*_p*} ]] && MY_PV="v${PV}"
	SRC_URI="
		mirror://githubcl/${PN}/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64"
	S="${WORKDIR}/${PN}-${MY_PV#v}"
fi

DESCRIPTION="Python wrapper around rapidjson"
HOMEPAGE="https://github.com/${PN}/${PN}"

LICENSE="MIT"
SLOT="0"
IUSE="test"

RDEPEND="
"
DEPEND="
	${RDEPEND}
"
distutils_enable_tests pytest

python_prepare_all() {
	distutils-r1_python_prepare_all
	ln -s "${EROOT}"/usr/include/rapidjson rapidjson/include
}
