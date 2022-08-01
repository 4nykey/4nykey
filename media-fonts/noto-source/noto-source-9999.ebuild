# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

FONT_SRCDIR=src
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/googlefonts/${PN}"
	EGIT_SUBMODULES=( )
else
	MY_PV="e173b59"
	SRC_URI="
		mirror://githubcl/googlefonts/${PN}/tar.gz/${MY_PV}
		-> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/${PN}-${MY_PV}"
fi
inherit fontmake

DESCRIPTION="A WIP versions of the noto fonts"
HOMEPAGE="https://github.com/googlefonts/${PN}"

LICENSE="OFL-1.1"
SLOT="0"
IUSE="clean-as-you-go"
RDEPEND="
	!media-fonts/croscorefonts
"

src_prepare() {
	use clean-as-you-go && HELPER_ARGS=( clean )
	# rm duplicates
	rm \
		src/NotoSansMalayalam-MM.glyphs \
		src/NotoSansGujarati-MM.glyphs \
		-f
	fontmake_src_prepare
}
