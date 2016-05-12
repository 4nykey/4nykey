# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )
inherit distutils-r1
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/googlei18n/${PN}.git"
else
	inherit vcs-snapshot
	MY_PV="626c2b2"
	SRC_URI="
		mirror://githubcl/googlei18n/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="A CFF table subroutinizer for FontTools"
HOMEPAGE="https://github.com/googlei18n/${PN}"

LICENSE=""
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="
	dev-python/fonttools
"
DEPEND="
	${RDEPEND}
	dev-python/setuptools
"
