# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

MY_PN="${PN^}Font"
FONT_TYPES=( otf +ttf )
FONTDIR_BIN=( fonts/{o,t}tf )
myemakeargs=(
	SRCDIR=sources
)
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/m4rc1e/${MY_PN}.git"
else
	inherit vcs-snapshot
	MY_PV="c50852e"
	SRC_URI="
		mirror://githubcl/m4rc1e/${MY_PN}/tar.gz/${MY_PV}
		-> ${P}.tar.gz
	"
	KEYWORDS="~amd64 ~x86"
fi
inherit fontmake

DESCRIPTION="A reworking of the classic gothic typeface style"
HOMEPAGE="https://github.com/m4rc1e/${MY_PN}"

LICENSE="OFL-1.1"
SLOT="0"
