# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/EbenSorkin/${PN}.git"
else
	inherit vcs-snapshot
	MY_PV="17311b9"
	[[ -n ${PV%%*_p*} ]] && MY_PV="v${PV}"
	SRC_URI="
		mirror://githubcl/EbenSorkin/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	KEYWORDS="~amd64 ~x86"
fi
inherit fontmake

DESCRIPTION="A serif font useful for creating long texts for books or articles"
HOMEPAGE="https://github.com/EbenSorkin/${PN}"

LICENSE="OFL-1.1"
SLOT="0"

DEPEND="
	!binary? ( dev-lang/perl )
"

src_prepare() {
	fontmake_src_prepare
	use binary && return
	perl -00pe \
		's:(.*)glyphname = i\.cy.*?(glyphname =.*):\1\2:s; \
		s:color = \(.+?\)\;::g' \
		-i "${S}"/sources/${PN^}*.glyphs
}
