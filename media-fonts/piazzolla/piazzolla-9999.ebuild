# Copyright 2019-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_FONT_VARIANTS=( smallcaps )
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/huertatipografica/${PN}.git"
	REQUIRED_USE="!binary"
else
	MY_PV="2aa8417"
	[[ -n ${PV%%*_p*} ]] && MY_PV="v${PV}"
	SRC_URI="https://github.com/huertatipografica/${PN}/releases/download/"
	SRC_URI="
		binary? (
			${SRC_URI}v${PV%_p*}/${PN^}.zip -> ${PN^}-${PV%_p*}.zip
			font_variants_smallcaps? (
				${SRC_URI}v${PV%_p*}/${PN^}SC.zip -> ${PN^}SC-${PV%_p*}.zip
			)
		)
		!binary? (
			mirror://githubcl/huertatipografica/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
		)
	"
	KEYWORDS="~amd64 ~x86"
	RESTRICT="primaryuri"
	S="${WORKDIR}/${PN}-${MY_PV#v}"
fi
inherit fontmake

DESCRIPTION="Type system intended for optimizing the available space in press media"
HOMEPAGE="https://piazzolla.huertatipografica.com"

LICENSE="OFL-1.1"
SLOT="0"
BDEPEND="
	binary? ( app-arch/unzip )
"
REQUIRED_USE+="
	binary? ( variable? ( !font_types_otf ) )
"

pkg_setup() {
	use binary && S="${S%/*}"
	if use variable; then
		FONTDIR_BIN=( ${PN^}{,SC}/variable/ttf )
	else
		FONTDIR_BIN=( ${PN^}{,SC}/static/{o,t}tf )
	fi
	fontmake_pkg_setup
}
