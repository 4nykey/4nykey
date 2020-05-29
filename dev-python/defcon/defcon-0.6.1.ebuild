# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 python3_{6,7} )
inherit distutils-r1
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/robotools/${PN}.git"
else
	MY_PV="${PV}"
	if [[ -z ${PV%%*_p*} ]]; then
		inherit vcs-snapshot
		MY_PV="486f10d"
	fi
	SRC_URI="
		mirror://githubcl/robotools/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="A set of UFO based objects for use in font editing applications"
HOMEPAGE="https://github.com/robotools/${PN}"

LICENSE="MIT"
SLOT="0"
IUSE="test"

RDEPEND="
	>=dev-python/fonttools-3.44[ufo(-),${PYTHON_USEDEP}]
	dev-python/compositor[${PYTHON_USEDEP}]
"
DEPEND="
	${RDEPEND}
"
PDEPEND="
	dev-python/fontPens[${PYTHON_USEDEP}]
"
distutils_enable_tests pytest
