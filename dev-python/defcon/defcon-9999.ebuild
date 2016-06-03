# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )
inherit distutils-r1
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/typesupply/${PN}.git"
	EGIT_BRANCH="ufo3"
else
	inherit vcs-snapshot
	MY_PV="61340fd"
	SRC_URI="
		mirror://githubcl/typesupply/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="A set of UFO based objects for use in font editing applications"
HOMEPAGE="https://github.com/typesupply/${PN}"

LICENSE="MIT"
SLOT="0"
IUSE=""

RDEPEND="
	dev-python/robofab
"
DEPEND="
	${RDEPEND}
"
