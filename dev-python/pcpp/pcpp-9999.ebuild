# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/ned14/${PN}.git"
else
	MY_PV="7a87581"
	[[ -n ${PV%%*_p*} ]] && MY_PV="v${PV}"
	MY_PLY="ply-fbc7a3c"
	SRC_URI="
		mirror://githubcl/ned14/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
		mirror://githubcl/dabeaz/${MY_PLY%-*}/tar.gz/${MY_PLY##*-} -> ${MY_PLY}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64"
	S="${WORKDIR}/${PN}-${MY_PV#v}"
fi

DESCRIPTION="A C99 preprocessor written in pure Python"
HOMEPAGE="https://pypi.python.org/pypi/pcpp"

LICENSE="BSD"
SLOT="0"
IUSE="test"

RDEPEND="
"
DEPEND="
	${RDEPEND}
"

python_prepare_all() {
	[[ -n ${PV%%*9999} ]] && mv "${WORKDIR}"/${MY_PLY}/* "${S}"/${PN}/ply
	sed -e '/LICENSE.txt/d' -i setup.py
	distutils-r1_python_prepare_all
}

python_test() {
	esetup.py test
}
