# Copyright 2018-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 python3_{6,7} )
inherit distutils-r1
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/${PN}/${PN}.git"
else
	MY_PV="${PV}"
	if [[ -z ${PV%%*_p*} ]]; then
		inherit vcs-snapshot
		MY_PV="5c85abd"
	fi
	SRC_URI="
		mirror://githubcl/${PN}/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="Improved build system generator for CPython extensions"
HOMEPAGE="https://github.com/${PN}/${PN}"

LICENSE="MIT"
SLOT="0"
IUSE=""

RDEPEND="
	dev-python/packaging[${PYTHON_USEDEP}]
"
DEPEND="
	${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
"

python_prepare_all() {
	distutils-r1_python_prepare_all
	sed \
		-e 's: bdist_wheel,::' \
		-e '/\<bdist_wheel\>/d' \
		-i skbuild/setuptools_wrap.py
}
