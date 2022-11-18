# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..10} )
inherit distutils-r1
MY_PN="${PN}.py"
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/simoncozens/${MY_PN}.git"
else
	MY_PV="9e8e6b2"
	[[ -n ${PV%%*_p*} ]] && MY_PV="v${PV}"
	SRC_URI="
		mirror://githubcl/simoncozens/${MY_PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/${MY_PN}-${MY_PV#v}"
fi

DESCRIPTION="Python bezier manipulation library"
HOMEPAGE="https://github.com/simoncozens/${MY_PN}"

LICENSE="MIT"
SLOT="0"
IUSE=""

RDEPEND="
	dev-python/pyclipper[${PYTHON_USEDEP}]
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	test? ( dev-python/dotmap[${PYTHON_USEDEP}] )
"
distutils_enable_tests pytest
