# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..10} )
inherit distutils-r1
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/simoncozens/${PN}.git"
else
	MY_PV="1d44333"
	[[ -n ${PV%%*_p*} ]] && MY_PV="v${PV}"
	SRC_URI="
		mirror://githubcl/simoncozens/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/${PN}-${MY_PV#v}"
fi

DESCRIPTION="Python library for manipulating OpenType font features"
HOMEPAGE="https://github.com/simoncozens/${PN}"

LICENSE="BSD"
SLOT="0"
IUSE="test"
RESTRICT+=" test"

RDEPEND="
	dev-python/glyphtools[${PYTHON_USEDEP}]
	dev-python/fonttools[ufo(-),${PYTHON_USEDEP}]
	dev-python/beziers[${PYTHON_USEDEP}]
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	test? ( dev-python/babelfont[${PYTHON_USEDEP}] )
"
distutils_enable_tests pytest
