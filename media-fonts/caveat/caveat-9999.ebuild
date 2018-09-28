# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

EMAKE_EXTRA_ARGS=( INTERPOLATE= )
FONTMAKE_EXTRA_ARGS=( '--no-subset' )
FONTDIR_BIN=( fonts/{OTF,TTF} )
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/googlefonts/${PN}.git"
else
	inherit vcs-snapshot
	MY_PV="a73b1a3"
	SRC_URI="
		mirror://githubcl/googlefonts/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	KEYWORDS="~amd64 ~x86"
fi
inherit fontmake

DESCRIPTION="Caveat handwriting fonts"
HOMEPAGE="https://github.com/googlefonts/${PN}"

LICENSE="OFL-1.1"
SLOT="0"
PATCHES=( "${FILESDIR}"/${PN}_che-cy.diff )
