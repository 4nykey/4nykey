# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

FONTDIR_BIN=( fonts/{CF,TT}F )
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/clauseggers/${PN}.git"
else
	inherit vcs-snapshot
	MY_PV="19d215d"
	[[ -n ${PV%%*_p*} ]] && MY_PV="${PV}"
	SRC_URI="
		mirror://githubcl/clauseggers/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	KEYWORDS="~amd64 ~x86"
fi
inherit fontmake

DESCRIPTION="An Open Source typeface family for display and titling use"
HOMEPAGE="https://github.com/clauseggers/${PN}"

LICENSE="OFL-1.1"
SLOT="0"
DEPEND="!binary? ( dev-lang/perl )"
PATCHES=(
	"${FILESDIR}"/${PN}-2.diff
)

src_prepare() {
	use binary || perl -0pe \
	's:(name = ["]?)_(.*["]?;\Rposition = .*;\R\},\R\{\Rname = ["]?_):\1\2:g;\
	s:_(circumflex|bar-):\1:g' -i sources/*.glyphs
	fontmake_src_prepare
}
