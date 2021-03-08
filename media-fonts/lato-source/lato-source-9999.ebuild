# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

EMAKE_EXTRA_ARGS=( glyphs="sources/Lato3Ita2M.designspace sources/Lato3Upr2M.designspace" )
FONTDIR_BIN=( build/Lato3{Ita,Upr}2M/static-{o,t}tf )
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/latofonts/${PN}.git"
else
	MY_PV="4fe347e"
	[[ -n ${PV%%*_p*} ]] && MY_PV="${PV}"
	SRC_URI="
		mirror://githubcl/latofonts/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/${PN}-${MY_PV}"
	RESTRICT="primaryuri"
fi
inherit fontmake

DESCRIPTION="A sanserif typeface family with classical proportions"
HOMEPAGE="https://www.latofonts.com"

LICENSE="OFL-1.1"
SLOT="0"
REQUIRED_USE="binary? ( variable? ( !font_types_otf ) )"

pkg_setup() {
	use variable && FONTDIR_BIN=( build/Lato3{Ita,Upr}2M/vf-2master )
	fontmake_pkg_setup
}
