# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..13} )
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/simoncozens/${PN}.git"
else
	MY_PV="dc89d8e"
	[[ -n ${PV%%*_p*} ]] && MY_PV="v${PV}"
	SRC_URI="
		mirror://githubcl/simoncozens/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64"
	S="${WORKDIR}/${PN}-${MY_PV#v}"
fi

DESCRIPTION="A user-friendlier way to use Harfbuzz in Python"
HOMEPAGE="https://github.com/simoncozens/${PN}"

LICENSE="MIT"
SLOT="0"
IUSE=""

RDEPEND="
	dev-python/fonttools[${PYTHON_USEDEP}]
	dev-python/uharfbuzz[${PYTHON_USEDEP}]
"
DEPEND="
	${RDEPEND}
"

python_prepare_all() {
	sed -e '/package_dir/s:Lib:lib:' -i setup.py
	distutils-r1_python_prepare_all
}
