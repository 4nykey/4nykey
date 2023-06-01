# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

FONTDIR_BIN=( fonts/{OTF,TTF} )
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/alexeiva/${PN}.git"
else
	inherit vcs-snapshot
	MY_PV="d99e30a"
	[[ -n ${PV%%*_p*} ]] && MY_PV="${PV}"
	SRC_URI="
		mirror://githubcl/alexeiva/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	KEYWORDS="~amd64"
fi
inherit fontmake

DESCRIPTION="An interpretation and expansion of the 1912 M. F. Benton's font"
HOMEPAGE="https://github.com/impallari/${PN}"

LICENSE="OFL-1.1"
SLOT="0"
PATCHES=( "${FILESDIR}"/${PN}_sterling.diff )
