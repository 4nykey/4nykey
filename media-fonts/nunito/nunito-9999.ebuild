# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

FONTDIR_BIN=( fonts/TTF )
EMAKE_EXTRA_ARGS=( VARLIB=' ' )
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/googlefonts/${PN}.git"
	EGIT_REPO_URI="https://github.com/alexeiva/${PN^}Font.git"
else
	inherit vcs-snapshot
	MY_PV="6d8a4e1"
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
