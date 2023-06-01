# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{10..11} )
inherit distutils-r1
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/drgrib/${PN}.git"
else
	MY_PV="c7a778a"
	[[ -n ${PV%%*_p*} ]] && MY_PV="${PV}"
	SRC_URI="
		mirror://githubcl/drgrib/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64"
	S="${WORKDIR}/${PN}-${MY_PV}"
fi

DESCRIPTION="Dot access dictionary with dynamic hierarchy creation and ordered iteration"
HOMEPAGE="https://github.com/drgrib/${PN}"

LICENSE="MIT"
SLOT="0"
IUSE=""

RDEPEND="
"
DEPEND="
	${RDEPEND}
"
distutils_enable_tests unittest
