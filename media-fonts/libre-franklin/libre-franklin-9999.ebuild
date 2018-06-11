# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

FONTDIR_BIN=( fonts/{OTF,TTF} )
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/alexeiva/${PN}.git"
else
	inherit vcs-snapshot
	MY_PV="c0fb9d7"
	[[ -n ${PV%%*_p*} ]] && MY_PV="${PV}"
	SRC_URI="
		mirror://githubcl/alexeiva/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	KEYWORDS="~amd64 ~x86"
fi
inherit fontmake

DESCRIPTION="An interpretation and expansion of the 1912 M. F. Benton's font"
HOMEPAGE="https://github.com/impallari/${PN}"

LICENSE="OFL-1.1"
SLOT="0"

src_prepare() {
	local PATCHES=(
		"${FILESDIR}"/${PN}_sterling.diff
	)
	fontmake_src_prepare
	mv -f sources/'For Single Fonts'/*.glyphs sources
}
