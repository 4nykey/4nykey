# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/FAlthausen/${PN}.git"
else
	inherit vcs-snapshot
	MY_PV="ff42913"
	MY_PB="${PN%-*}-${PV%_p*}"
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
DOCS=( Fontlog.txt )
