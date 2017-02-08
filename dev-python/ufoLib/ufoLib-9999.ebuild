# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{4,5} )
inherit distutils-r1
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/unified-font-object/${PN}.git"
else
	if [[ -z ${PV%%*_p*} ]]; then
		inherit vcs-snapshot
		MY_PV="5526dc8"
		SRC_URI="
			mirror://githubcl/unified-font-object/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
		"
	else
		SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.zip"
		DEPEND="app-arch/unzip"
	fi
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="A low-level UFO reader and writer"
HOMEPAGE="https://github.com/unified-font-object/${PN}"

LICENSE="BSD"
SLOT="0"
IUSE="test"

RDEPEND="
	>=dev-python/fonttools-3.1.2[${PYTHON_USEDEP}]
"
DEPEND="
	${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( dev-python/pytest-runner[${PYTHON_USEDEP}] )
"

python_test() {
	esetup.py test || die
}
