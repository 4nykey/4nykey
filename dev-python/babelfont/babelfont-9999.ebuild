# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{9..11} )
DISTUTILS_USE_PEP517=poetry
inherit distutils-r1
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/simoncozens/${PN}.git"
else
	MY_PV="668f8ed"
	[[ -n ${PV%%*_p*} ]] && MY_PV="v${PV}"
	SRC_URI="
		mirror://githubcl/simoncozens/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/${PN}-${MY_PV#v}"
fi

DESCRIPTION="Interrogate and manipulate UFO, TTF and OTF fonts with a common interface"
HOMEPAGE="https://github.com/simoncozens/${PN}"

LICENSE="MIT"
SLOT="0"
IUSE="test"

RDEPEND="
	dev-python/orjson[${PYTHON_USEDEP}]
	dev-python/fonttools[ufo(-),${PYTHON_USEDEP}]
	dev-python/ufoLib2[${PYTHON_USEDEP}]
	dev-python/openstep-plist[${PYTHON_USEDEP}]
	dev-python/glyphsLib[${PYTHON_USEDEP}]
	dev-python/fontFeatures[${PYTHON_USEDEP}]
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	test? ( dev-python/defcon[${PYTHON_USEDEP}] )
"
PATCHES=( "${FILESDIR}"/cu2qu.diff )
distutils_enable_tests pytest
