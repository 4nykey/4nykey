# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_FONT_TYPES=( otf +ttf )
FONTDIR_BIN=( fonts/otf fonts/TTF )
FONT_SRCDIR='source'
FONTMAKE_EXTRA_ARGS=( '--no-check-compatibility' )
MY_PN="${PN^}"
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/impallari/${MY_PN}"
else
	MY_PV="7e0be84"
	SRC_URI="
		mirror://githubcl/impallari/${MY_PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	KEYWORDS="~amd64"
	S="${WORKDIR}/${MY_PN}-${MY_PV}"
fi
inherit fontmake

DESCRIPTION="An elegant sans-serif typeface"
HOMEPAGE="https://github.com/impallari/${MY_PN}"

LICENSE="OFL-1.1"
SLOT="0"
REQUIRED_USE="binary? ( variable? ( !font_types_otf ) )"

pkg_setup() {
	use variable && FONTDIR_BIN=( fonts/vf )
	fontmake_pkg_setup
}
