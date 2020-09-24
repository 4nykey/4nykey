# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8} )
inherit distutils-r1
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/robotools/${PN}.git"
else
	MY_PV="v${PV}"
	if [[ -z ${PV%%*_p*} ]]; then
		inherit vcs-snapshot
		MY_PV="101eb70"
	fi
	SRC_URI="
		mirror://githubcl/robotools/${PN}/tar.gz/${MY_PV}
		-> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="A collection of classes implementing the pen protocol for manipulating glyphs"
HOMEPAGE="https://github.com/robotools/${PN}"

LICENSE="BSD"
SLOT="0"
IUSE="test"

RDEPEND="
	>=dev-python/fonttools-3.32[ufo(-),${PYTHON_USEDEP}]
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	test? (
		dev-python/fontParts[${PYTHON_USEDEP}]
	)
"
distutils_enable_tests pytest
