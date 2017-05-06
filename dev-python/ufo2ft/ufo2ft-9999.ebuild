# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{4,5} )
inherit distutils-r1
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/googlei18n/${PN}.git"
else
	inherit vcs-snapshot
	MY_PV="f78d3fa"
	[[ -n ${PV%%*_p*} ]] && MY_PV="v${PV}"
	SRC_URI="
		mirror://githubcl/googlei18n/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="A bridge from UFOs to FontTool objects"
HOMEPAGE="https://github.com/googlei18n/${PN}"

LICENSE="MIT"
SLOT="0"
IUSE="test"

RDEPEND="
	>=dev-python/fonttools-3.7.0[${PYTHON_USEDEP}]
	dev-python/ufoLib[${PYTHON_USEDEP}]
	dev-python/defcon[${PYTHON_USEDEP}]
	dev-python/cu2qu[${PYTHON_USEDEP}]
	dev-python/compreffor[${PYTHON_USEDEP}]
"
DEPEND="
	${RDEPEND}
	test? ( dev-python/pytest-runner[${PYTHON_USEDEP}] )
"
PATCHES=(
	"${FILESDIR}"/${PN}-heightfallback.diff
)

python_test() {
	esetup.py test
}
