# Copyright 2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{4,5,6,7} )
inherit distutils-r1
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/${PN}/${PN}.git"
else
	inherit vcs-snapshot
	MY_PV="5c85abd"
	[[ -n ${PV%%*_p*} ]] && MY_PV="${PV}"
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
