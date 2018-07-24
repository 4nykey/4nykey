# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

EMAKE_EXTRA_ARGS=(
	glyphs=sources/${PN}-build-italic.designspace
	glyphs+=sources/${PN}-build-roman.designspace
)
FONTDIR_BIN=( fonts/desktop{,_otf} fonts/sc{,_otf} )
MY_FONT_VARIANTS=( smallcaps )
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/productiontype/${PN}.git"
else
	inherit vcs-snapshot
	MY_PV="1d908f3"
	[[ -n ${PV%%*_p*} ]] && MY_PV="v${PV}"
	SRC_URI="
		mirror://githubcl/productiontype/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	KEYWORDS="~amd64 ~x86"
fi
inherit fontmake

DESCRIPTION="A serif typeface for text-rich, screen-first environments and long-form reading"
HOMEPAGE="https://github.com/productiontype/${PN}"

LICENSE="OFL-1.1"
SLOT="0"
DOCS=( contributors.txt )

src_prepare() {
	ln -s . sources/instance_ufo
	fontmake_src_prepare
}
