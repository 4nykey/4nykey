# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{10..11} )
inherit distutils-r1
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/simoncozens/${PN}.git"
else
	MY_PV="12b2053"
	[[ -n ${PV%%*_p*} ]] && MY_PV="v${PV}"
	SRC_URI="
		mirror://githubcl/simoncozens/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64"
	S="${WORKDIR}/${PN}-${MY_PV#v}"
fi

DESCRIPTION="Routines for extracting information from font glyphs"
HOMEPAGE="https://github.com/simoncozens/${PN}"

LICENSE="Apache-2.0"
SLOT="0"
IUSE=""

RDEPEND="
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/beziers[${PYTHON_USEDEP}]
	dev-python/glyphsLib[${PYTHON_USEDEP}]
"
DEPEND="
	${RDEPEND}
"
distutils_enable_tests pytest
