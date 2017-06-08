# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

MY_PN="${PN^}-Cyrillic"
MAKEOPTS+=" INTERPOLATE="
FONTDIR_BIN=( fonts/{OTF,ttf} )
PATCHES=(
	"${FILESDIR}"/${PN}_cyrbreve.diff
)
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/cyrealtype/${MY_PN}.git"
else
	inherit vcs-snapshot
	MY_PV="eeea0ae"
	SRC_URI="
		mirror://githubcl/cyrealtype/${MY_PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	KEYWORDS="~amd64 ~x86"
fi
inherit fontmake

DESCRIPTION="A well-balanced contemporary serif with roots in calligraphy"
HOMEPAGE="https://github.com/cyrealtype/${PN}"

LICENSE="OFL-1.1"
SLOT="0"
