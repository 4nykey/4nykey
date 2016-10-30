# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

FONT_TYPES="otf ttf"
if [[ ${PV} == *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/vernnobile/OswaldFont.git"
else
	inherit vcs-snapshot
	MY_PV="9dd0521"
	SRC_URI="
		mirror://githubcl/vernnobile/OswaldFont/tar.gz/${MY_PV}
		-> ${P}.tar.gz
	"
	KEYWORDS="~amd64 ~x86"
	RESTRICT="primaryuri"
fi
inherit versionator font-r1
S="${WORKDIR}/${P}/$(get_version_component_range -2)"

DESCRIPTION="A reworking of the classic gothic typeface style"
HOMEPAGE="https://github.com/vernnobile/OswaldFont"

LICENSE="OFL-1.1"
SLOT="0"
IUSE=""

FONT_S=( {Italic,Roman}/{2,3,4,5,6,7,8}00/{.,src} )
