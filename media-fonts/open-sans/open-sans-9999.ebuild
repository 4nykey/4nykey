# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PN="opensans"
FONT_SRCDIR="source"
EMAKE_EXTRA_ARGS=( glyphs='source/OpenSans-Roman.glyphs source/OpenSans-Italic.glyphs' )
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/googlefonts/${MY_PN}.git"
	EGIT_REPO_URI="https://github.com/laerm0/${MY_PN}.git"
else
	inherit vcs-snapshot
	MY_PV="c1ac1c0"
	SRC_URI="
		mirror://githubcl/googlefonts/${MY_PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	KEYWORDS="~amd64 ~x86"
fi
inherit fontmake

HOMEPAGE="https://github.com/googlefonts/${MY_PN}"
DESCRIPTION="A clean and modern sans-serif typeface for web, print and mobile"

LICENSE="Apache-2.0"
SLOT="0"
REQUIRED_USE="binary? ( !font_types_otf )"
PATCHES=( "${FILESDIR}"/${PN}_familyname.diff )
