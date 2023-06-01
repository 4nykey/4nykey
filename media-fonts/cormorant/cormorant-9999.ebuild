# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PN="${PN^}"
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/CatharsisFonts/${MY_PN}.git"
else
	MY_PV="8800b8b"
	[[ -n ${PV%%*_p*} ]] && MY_PV="v${PV}"
	SRC_URI="
		mirror://githubcl/CatharsisFonts/${MY_PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	KEYWORDS="~amd64"
	S="${WORKDIR}/${MY_PN}-${MY_PV#v}"
fi
inherit fontmake

DESCRIPTION="An extravagant display serif typeface"
HOMEPAGE="https://github.com/CatharsisFonts/${MY_PN}"

LICENSE="OFL-1.1"
SLOT="0"
FONTDIR_BIN=( '1. TrueType Font Files' '2. OpenType Files' )

src_prepare() {
	ln -s "4. Glyphs Source Files" sources
	fontmake_src_prepare
}
