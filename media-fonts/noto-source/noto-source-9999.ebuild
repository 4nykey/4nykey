# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

FONT_SRCDIR=src
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/googlefonts/${PN}"
else
	inherit vcs-snapshot
	MY_PV="4f16288"
	SRC_URI="
		mirror://githubcl/googlefonts/${PN}/tar.gz/${MY_PV}
		-> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi
inherit fontmake

DESCRIPTION="A WIP versions of the noto fonts"
HOMEPAGE="https://github.com/googlefonts/${PN}"

LICENSE="OFL-1.1"
SLOT="0"
IUSE="clean-as-you-go +interpolate"

src_prepare() {
	rm -rf src/NotoSansTifinagh-Regular.glyphs src/NotoSansTifinagh
	sed -e '/GPOS/s:Regular ::' \
		-i src/NotoSansKharoshthi/NotoSansKharoshthi.plist
	sed -e 's:\.\./build/instance_ufos:../instance_ufo:' \
		-i src/NotoSansHanifiRohingya/NotoSansHanifiRohingya.designspace
	fontmake_src_prepare
}
