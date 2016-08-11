# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python2_7 )
inherit distutils-r1
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/typesupply/${PN}.git"
else
	inherit vcs-snapshot
	MY_PV="ad4d1d3"
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
	dev-python/fonttools
	dev-python/ufoLib
	dev-python/compositor
"
DEPEND="
	${RDEPEND}
"
