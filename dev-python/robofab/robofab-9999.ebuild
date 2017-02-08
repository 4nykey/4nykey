# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python2_7 )
inherit distutils-r1
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/robofab-developers/${PN}.git"
else
	inherit vcs-snapshot
	MY_PV="62229c4"
	SRC_URI="
		mirror://githubcl/robofab-developers/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="A library for fonts and type design"
HOMEPAGE="http://robofab.org"

LICENSE="BSD"
SLOT="0"
IUSE=""

DEPEND="
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/fonttools[${PYTHON_USEDEP}]
"
RDEPEND="
	${DEPEND}
"
