# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

MY_FONT_TYPES=( otf +ttf )
FONTDIR_BIN=( fonts/TTF )
FONT_SRCDIR='source'
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/impallari/${PN}"
	EGIT_REPO_URI="https://github.com/alexeiva/${PN}"
else
	inherit vcs-snapshot
	MY_PV="98add57"
	SRC_URI="
		mirror://githubcl/impallari/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	KEYWORDS="~amd64 ~x86"
fi
inherit fontmake

DESCRIPTION="An elegant sans-serif typeface"
HOMEPAGE="https://github.com/impallari/${PN}"

LICENSE="OFL-1.1"
SLOT="0"
REQUIRED_USE="binary? ( !font_types_otf )"
