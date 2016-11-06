# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python2_7 )
inherit distutils-r1
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/davelab6/${PN}.git"
else
	inherit vcs-snapshot
	MY_PV="b20d185"
	SRC_URI="
		mirror://githubcl/davelab6/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="A tool to check font files for language/character set support"
HOMEPAGE="https://github.com/davelab6/${PN}"

LICENSE="GPL-3"
SLOT="0"
IUSE="icu"

RDEPEND="
	dev-python/lxml[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	dev-python/tabulate[${PYTHON_USEDEP}]
	dev-python/fonttools[${PYTHON_USEDEP}]
	icu? ( dev-python/pyicu[${PYTHON_USEDEP}] )
"
DEPEND="
	${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
"
