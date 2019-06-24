# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

FONTDIR_BIN=( fonts/ttfs )
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/SorkinType/${PN}.git"
else
	inherit vcs-snapshot
	MY_PV="8a1b078"
	SRC_URI="
		mirror://githubcl/SorkinType/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	KEYWORDS="~amd64 ~x86"
fi
inherit fontmake

DESCRIPTION="A sans font useful for creating long texts for books or articles"
HOMEPAGE="https://github.com/SorkinType/${PN}"

LICENSE="OFL-1.1"
SLOT="0"
REQUIRED_USE="binary? ( !font_types_otf )"
