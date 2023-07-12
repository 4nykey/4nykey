# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

FONTDIR_BIN=( distr/{o,t}tf )
FONT_SRCDIR=.
MY_PN="FiraCode"
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/tonsky/${MY_PN}"
	REQUIRED_USE="!binary"
else
	MY_PV="ba21c00"
	[[ -n ${PV%%*_p*} ]] && MY_PV="${PV}"
	SRC_URI="
	!binary? (
		mirror://githubcl/tonsky/${MY_PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	)
	binary? (
		https://github.com/tonsky/${MY_PN}/releases/download/${PV%_p*}/Fira_Code_v${PV%_p*}.zip
	)
	"
	KEYWORDS="~amd64"
	S="${WORKDIR}/${MY_PN}-${MY_PV}"
fi
inherit fontmake

DESCRIPTION="A monospaced font with programming ligatures"
HOMEPAGE="https://github.com/tonsky/${MY_PN}"

LICENSE="OFL-1.1"
SLOT="0"
BDEPEND="
	binary? ( app-arch/unzip )
"
REQUIRED_USE+="
	binary? ( !font_types_otf )
"

pkg_setup() {
	use binary && S="${S%/*}"
	FONTDIR_BIN=( $(usex variable variable_ttf ttf) )
	fontmake_pkg_setup
}
