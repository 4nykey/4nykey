# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

FONT_TYPES=( otf +ttf )
myemakeargs=(
	SRCDIR=sources
	INTERPOLATE=
)
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/ossobuffo/${PN}.git"
else
	inherit vcs-snapshot
	MY_PV="8f55b34"
	SRC_URI="
		mirror://githubcl/ossobuffo/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	KEYWORDS="~amd64 ~x86"
fi
inherit fontmake

DESCRIPTION="A sans-serif typeface similar to the one often used in elementary classrooms"
HOMEPAGE="http://danieljohnson.name/fonts/${PN}"

LICENSE="OFL-1.1"
SLOT="0"
