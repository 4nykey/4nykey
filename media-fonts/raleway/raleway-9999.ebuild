# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

FONT_TYPES=( +otf ttf )
FONTDIR_BIN=( fonts/v${PV//.} )
myemakeargs=(
	SRCDIR=source
	FAMILY=${PN^}
)
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/impallari/${PN}"
else
	inherit vcs-snapshot
	MY_PV="6c67ab1"
	SRC_URI="
		mirror://githubcl/impallari/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	KEYWORDS="~amd64 ~x86"
fi
inherit fontmake

DESCRIPTION="An elegant sans-serif typeface"
HOMEPAGE="http://www.impallari.com/projects/overview/matt-mcinerneys-raleway-family"

LICENSE="OFL-1.1"
SLOT="0"
