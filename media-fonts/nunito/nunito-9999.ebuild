# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

FONTDIR_BIN=( fonts/TTF )
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/googlefonts/${PN}.git"
	EGIT_REPO_URI="https://github.com/alexeiva/${PN}.git"
else
	inherit vcs-snapshot
	MY_PV="3437281"
	SRC_URI="
		mirror://githubcl/googlefonts/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	KEYWORDS="~amd64 ~x86"
fi
inherit fontmake

DESCRIPTION="A well balanced Sans Serif with rounded terminals"
HOMEPAGE="https://github.com/googlefonts/${PN}"

LICENSE="OFL-1.1"
SLOT="0"
REQUIRED_USE="binary? ( !font_types_otf )"
PATCHES=(
	"${FILESDIR}"/${PN}_ef-cy.diff
	"${FILESDIR}"/${PN}_heavy.diff
)
