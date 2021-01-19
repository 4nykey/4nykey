# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PN="Playfair-Display"
EMAKE_EXTRA_ARGS=(
	glyphs='sources/Playfair-2-Italic.glyphs sources/Playfair-2-Roman.glyphs'
	VARLIB=' '
)
FONTDIR_BIN=( fonts/{CF,TT}F )
SLOT="2"
FONT_PN="${PN}-${SLOT}"
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/clauseggers/${MY_PN}.git"
else
	MY_PV="65e767a"
	[[ -n ${PV%%*_p*} ]] && MY_PV="${PV}"
	SRC_URI="
		mirror://githubcl/clauseggers/${MY_PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/${MY_PN}-${MY_PV}"
fi
inherit fontmake

DESCRIPTION="An Open Source typeface family for display and titling use"
HOMEPAGE="https://github.com/clauseggers/${MY_PN}"

LICENSE="OFL-1.1"
REQUIRED_USE="!binary"
