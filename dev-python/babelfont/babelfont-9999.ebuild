# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..10} )
inherit distutils-r1
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/simoncozens/${PN}.git"
else
	MY_PV="05d983c"
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
	dev-python/defcon[${PYTHON_USEDEP}]
	dev-python/fontParts[${PYTHON_USEDEP}]
	dev-python/fonttools[ufo(-),${PYTHON_USEDEP}]
	dev-python/glyphsLib[${PYTHON_USEDEP}]
"
DEPEND="
	${RDEPEND}
"
distutils_enable_tests pytest
