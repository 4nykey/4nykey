# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8} )
inherit distutils-r1
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/robotools/${PN}.git"
else
	if [[ -z ${PV%%*_p*} ]]; then
		inherit vcs-snapshot
		MY_PV="5aae469"
	fi
	MY_PV="v${PV}"
	SRC_URI="
		mirror://githubcl/robotools/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="Tools for extracting data from font binaries into UFO objects"
HOMEPAGE="https://github.com/robotools/${PN}"

LICENSE="MIT"
SLOT="0"
IUSE="test"

RDEPEND="
	>=dev-python/fonttools-3.31[ufo(-),${PYTHON_USEDEP}]
"
DEPEND="
	${RDEPEND}
"
distutils_enable_tests pytest
