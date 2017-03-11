# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

MY_PN="${PN^}-Cyrillic"
FONT_TYPES=( otf +ttf )
myemakeargs=(
	SRCDIR=sources
	INTERPOLATE=
)
PATCHES=(
	"${FILESDIR}"/${PN}_overlaps.diff
)
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/cyrealtype/${MY_PN}.git"
else
	inherit vcs-snapshot
	MY_PV="4fc1f25"
	SRC_URI="
		mirror://githubcl/cyrealtype/${MY_PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	KEYWORDS="~amd64 ~x86"
fi
inherit fontmake

DESCRIPTION="A font with regular proportions and medium contrast designed for headlines"
HOMEPAGE="https://github.com/cyrealtype/${MY_PN}"

LICENSE="OFL-1.1"
SLOT="0"