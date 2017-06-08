# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/huertatipografica/${PN}.git"
	EGIT_BRANCH="dev"
else
	inherit vcs-snapshot
	MY_PV="064532e"
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
