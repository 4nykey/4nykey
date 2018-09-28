# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/CatharsisFonts/${PN}.git"
else
	inherit vcs-snapshot
	MY_PV="60eea25"
	[[ -n ${PV%%*_p*} ]] && MY_PV="v${PV}"
	SRC_URI="
		mirror://githubcl/CatharsisFonts/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	KEYWORDS="~amd64 ~x86"
fi
inherit fontmake

DESCRIPTION="An extravagant display serif typeface"
HOMEPAGE="https://github.com/CatharsisFonts/${PN}"

LICENSE="OFL-1.1"
SLOT="0"
FONTDIR_BIN=( '1. TrueType Font Files' '2. OpenType Files' )

src_prepare() {
	fontmake_src_prepare
	use binary && return
	eapply "${FILESDIR}"/${PN}-features.diff
	ln -s "4. Glyphs Source Files" sources
	rm -f src/*_BACKUP.glyphs
}
