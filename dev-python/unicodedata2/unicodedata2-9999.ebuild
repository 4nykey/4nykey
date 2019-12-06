# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 python3_{5,6,7} )
inherit distutils-r1
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/mikekap/${PN}.git"
else
	MY_PV="${PV/_p/-}"
	if [[ -z ${PV%%*_p*} ]]; then
		inherit vcs-snapshot
		MY_PV="45378d5"
	fi
	SRC_URI="
		mirror://githubcl/mikekap/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="Unicodedata backport for python 2/3 updated to the latest unicode version"
HOMEPAGE="https://github.com/mikekap/${PN}"

LICENSE="Apache-2.0"
SLOT="0"
IUSE="test"

RDEPEND="
"
DEPEND="
	${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
"
BDEPEND="
	test? ( dev-python/pytest[${PYTHON_USEDEP}] )
"

python_test() {
	esetup.py test
}
