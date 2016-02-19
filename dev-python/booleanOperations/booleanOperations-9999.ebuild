# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )
inherit distutils-r1
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/typemytype/${PN}.git"
else
	inherit vcs-snapshot
	SRC_URI="
		mirror://githubcl/typemytype/${PN}/tar.gz/${PV} -> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="A library for boolean operations on paths"
HOMEPAGE="https://github.com/typemytype/${PN}"

LICENSE="MIT"
SLOT="0"
IUSE=""

RDEPEND="
	>=dev-python/cython-0.23.4
"
DEPEND="
	${RDEPEND}
	dev-python/setuptools
"
