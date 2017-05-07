# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

FONT_TYPES=( otf +ttf )
myemakeargs=(
	SRCDIR=sources
)
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/FAlthausen/${PN}.git"
else
	inherit vcs-snapshot
	MY_PV="3c1909a"
	SRC_URI="
		mirror://githubcl/FAlthausen/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	KEYWORDS="~amd64 ~x86"
fi
inherit fontmake

DESCRIPTION="A body typeface with figure sets, ligatures and contextual alternates"
HOMEPAGE="http://vollkorn-typeface.com"

LICENSE="OFL-1.1"
SLOT="0"
REQUIRED_USE="binary? ( !font_types_otf )"
