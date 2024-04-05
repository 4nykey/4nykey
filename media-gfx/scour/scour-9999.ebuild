# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/${PN}-project/${PN}.git"
else
	MY_PV="565686a"
	[[ -n ${PV%%*_p*} ]] && MY_PV="v${PV}"
	SRC_URI="
		mirror://githubcl/${PN}-project/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64"
	S="${WORKDIR}/${PN}-${MY_PV#v}"
fi

DESCRIPTION="An SVG Optimizer / Cleaner"
HOMEPAGE="https://github.com/scour-project/scour"

LICENSE="Apache-2.0"
SLOT="0"

RDEPEND="
"
DEPEND="
	${RDEPEND}
"
distutils_enable_tests unittest
