# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

FONTDIR_BIN=( distr/{o,t}tf )
EMAKE_EXTRA_ARGS=( glyphs='FiraCode.glyphs' )
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/tonsky/${PN}"
else
	inherit vcs-snapshot
	SRC_URI="mirror://githubcl/tonsky/${PN}/tar.gz/${PV} -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi
inherit fontmake

DESCRIPTION="A monospaced font with programming ligatures"
HOMEPAGE="https://github.com/tonsky/${PN}"

LICENSE="OFL-1.1"
SLOT="0"

src_prepare() {
	fontmake_src_prepare
	sed -e 's:\\\\::g' -i FiraCode.glyphs || die
}
