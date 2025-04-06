# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..13} )
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1
MY_PN="${PN}-python"
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/${PN}/${MY_PN}.git"
else
	inherit vcs-snapshot
	MY_PV="b212507"
	[[ -n ${PV%%*_p*} ]] && MY_PV="v${PV}"
	SRC_URI="
		mirror://githubcl/${PN}/${MY_PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64"
fi

DESCRIPTION="Python implementation of HSLuv (revision 4)"
HOMEPAGE="https://www.hsluv.org/"

LICENSE="MIT"
SLOT="0"
IUSE=""

RDEPEND="
"
DEPEND="
	${RDEPEND}
"
distutils_enable_tests pytest
