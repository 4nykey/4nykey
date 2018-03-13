# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/huertatipografica/${PN}.git"
else
	inherit vcs-snapshot
	MY_PV="af2cf4e"
	[[ -n ${PV%%*_p*} ]] && MY_PV="v${PV/_/-}"
	SRC_URI="
		mirror://githubcl/huertatipografica/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	KEYWORDS="~amd64 ~x86"
fi
inherit fontmake

DESCRIPTION="A serif typeface originally intended for literature"
HOMEPAGE="https://github.com/huertatipografica/${PN}"

LICENSE="OFL-1.1"
SLOT="0"

PATCHES=(
	"${FILESDIR}"/${PN}_toomanyalignmentzones.diff
)
