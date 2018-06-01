# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

FONT_S=( IBM-Plex-{Mono,Sans-Condensed,Sans,Serif}/fonts/complete/{o,t}tf )
MY_FONT_TYPES=( otf +ttf )
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/IBM/${PN}.git"
else
	inherit vcs-snapshot
	MY_PV="376a2e2"
	[[ -n ${PV%%*_p*} ]] && MY_PV="v${PV}"
	SRC_URI="
		mirror://githubcl/IBM/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi
inherit font-r1

DESCRIPTION="IBM's typeface"
HOMEPAGE="https://IBM.com/typefaces/FiraGO"

LICENSE="OFL-1.1"
SLOT="0"
DOCS=( CHANGELOG )
