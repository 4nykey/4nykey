# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="Playfair"
FONTDIR_BIN=( fonts/Static-CFF )
SLOT="2"
FONT_PN="${PN}-${SLOT}"
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/clauseggers/${MY_PN}.git"
else
	MY_PV="e810924"
	[[ -n ${PV%%*_p*} ]] && MY_PV="$(ver_rs 2 '-' 3 '-')"
	MY_PV="${MY_PV/rc/RC}"
	SRC_URI="
		mirror://githubcl/clauseggers/${MY_PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	KEYWORDS="~amd64"
	S="${WORKDIR}/${MY_PN}-${MY_PV}"
fi
inherit fontmake

DESCRIPTION="An Open Source typeface family for display and titling use"
HOMEPAGE="https://github.com/clauseggers/${MY_PN}"

LICENSE="OFL-1.1"
REQUIRED_USE+="
	binary? (
		variable? ( font_types_ttf )
		!variable? ( font_types_otf )
	)
"

pkg_setup() {
	use variable && FONTDIR_BIN=( fonts/VF-TTF )
	fontmake_pkg_setup
}
