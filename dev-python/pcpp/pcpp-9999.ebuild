# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_{6,7} )
inherit distutils-r1
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/ned14/${PN}.git"
else
	inherit vcs-snapshot
	MY_PV="7a87581"
	[[ -n ${PV%%*_p*} ]] && MY_PV="v${PV}"
	MY_PLY="ply-dca6c60"
	SRC_URI="
		mirror://githubcl/ned14/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
		mirror://githubcl/dabeaz/${MY_PLY%-*}/tar.gz/${MY_PLY##*-} -> ${MY_PLY}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
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
	distutils-r1_python_prepare_all
}

python_test() {
	esetup.py test
}
