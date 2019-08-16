# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

EMAKE_EXTRA_ARGS=(
	glyphs='sources/Playfair-2-Italic.glyphs sources/Playfair-2-Roman.glyphs'
	VARLIB=' '
)
FONTDIR_BIN=( fonts/{CF,TT}F )
FONT_PN="${PN}-${SLOT}"
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/clauseggers/${PN}.git"
else
	MY_PV="${PV}"
	if [[ -z ${PV%%*_p*} ]]; then
		inherit vcs-snapshot
		MY_PV="1b73412"
	fi
	SRC_URI="
		mirror://githubcl/clauseggers/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	KEYWORDS="~amd64 ~x86"
fi
inherit fontmake

DESCRIPTION="An Open Source typeface family for display and titling use"
HOMEPAGE="https://github.com/clauseggers/${PN}"

LICENSE="OFL-1.1"
SLOT="2"
REQUIRED_USE="!binary"
