# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

FONTDIR_BIN=( distr/{o,t}tf )
FONT_SRCDIR=.
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
