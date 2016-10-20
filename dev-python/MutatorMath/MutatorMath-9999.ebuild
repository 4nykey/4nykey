# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{4,5} )
inherit distutils-r1
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/LettError/${PN}.git"
else
	inherit vcs-snapshot
	MY_PV="652b075"
	SRC_URI="
		mirror://githubcl/LettError/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="A library for piecewise linear interpolation in multiple dimensions"
HOMEPAGE="https://github.com/LettError/${PN}"

LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	dev-python/defcon[${PYTHON_USEDEP}]
	dev-python/fontMath[${PYTHON_USEDEP}]
	dev-python/ufoLib[${PYTHON_USEDEP}]
"
DEPEND="
	${RDEPEND}
"
