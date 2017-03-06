# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

FONT_TYPES=( otf +ttf )
myemakeargs=( SRCDIR=sources )
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/etunni/${PN}.git"
else
	inherit vcs-snapshot
	MY_PV="bb84431"
	SRC_URI="
		mirror://githubcl/etunni/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	KEYWORDS="~amd64 ~x86"
fi
inherit fontmake

DESCRIPTION="A Latin, Cyrillic and Devanagari typeface derived from Gabriela"
HOMEPAGE="https://github.com/etunni/${PN}"

LICENSE="OFL-1.1"
SLOT="0"

src_prepare() {
	fontmake_src_prepare
	sed -e '/color = (/d' -i "${S}"/sources/${PN^}*.glyphs
}
