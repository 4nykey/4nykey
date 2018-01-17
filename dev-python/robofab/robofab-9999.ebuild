# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )
inherit distutils-r1
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/robofab-developers/${PN}.git"
	EGIT_BRANCH="ufo3k"
else
	inherit vcs-snapshot
	MY_PV="7fa069c"
	SRC_URI="
		mirror://githubcl/robofab-developers/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="A library for fonts and type design"
HOMEPAGE="http://robofab.org"

LICENSE="BSD"
SLOT="0"
IUSE=""

DEPEND="
	dev-python/fonttools[${PYTHON_USEDEP}]
	dev-python/ufoLib[${PYTHON_USEDEP}]
"
RDEPEND="
	${DEPEND}
"

python_prepare_all() {
	sed -e '/ufoLib/d' -i setup.py
	distutils-r1_python_prepare_all
}
