# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{4,5} )
inherit distutils-r1
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/googlei18n/${PN}.git"
else
	inherit vcs-snapshot
	MY_PV="97e8693"
	SRC_URI="
		mirror://githubcl/googlei18n/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="A wrapper for several Python libraries to compile fonts from sources"
HOMEPAGE="https://github.com/googlei18n/${PN}"

LICENSE="Apache-2.0"
SLOT="0"
IUSE=""

RDEPEND="
	dev-python/cu2qu[${PYTHON_USEDEP}]
	dev-python/glyphsLib[${PYTHON_USEDEP}]
	dev-python/ufo2ft[${PYTHON_USEDEP}]
	dev-python/MutatorMath[${PYTHON_USEDEP}]
	dev-python/booleanOperations[${PYTHON_USEDEP}]
	dev-python/defcon[${PYTHON_USEDEP}]
	media-gfx/ttfautohint
"
DEPEND="
	${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
"
