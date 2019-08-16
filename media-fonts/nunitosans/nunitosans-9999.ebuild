# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

FONTDIR_BIN=( fonts/TTF )
EMAKE_EXTRA_ARGS=( VARLIB=' ' )
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/Fonthausen/${PN}.git"
else
	inherit vcs-snapshot
	MY_PV="5fc7eb2"
	SRC_URI="
		mirror://githubcl/alexeiva/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	KEYWORDS="~amd64 ~x86"
fi
inherit fontmake

DESCRIPTION="A well balanced sans serif typeface superfamily"
HOMEPAGE="https://github.com/Fonthausen/${PN}"

LICENSE="OFL-1.1"
SLOT="0"
REQUIRED_USE="binary? ( !font_types_otf )"
PATCHES=(
	"${FILESDIR}"/${PN}_brevecomb-cy.diff
	"${FILESDIR}"/${PN}_heavy.diff
)
