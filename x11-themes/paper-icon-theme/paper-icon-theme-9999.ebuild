# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit gnome2 autotools-utils
if [[ -z ${PV%%*9999} ]]; then
	SRC_URI=""
	EGIT_REPO_URI="https://github.com/snwh/${PN}.git"
	inherit git-r3
else
	inherit vcs-snapshot
	MY_PV="ae82c98"
	SRC_URI="
		mirror://githubcl/snwh/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="A simple and modern icon theme with material design influences"
HOMEPAGE="http://snwh.org/paper"

LICENSE="CC-BY-SA-4.0"
SLOT="0"
IUSE=""

DEPEND=""
RDEPEND="
	${DEPEND}
"
AUTOTOOLS_AUTORECONF=1
AUTOTOOLS_IN_SOURCE_BUILD=1
