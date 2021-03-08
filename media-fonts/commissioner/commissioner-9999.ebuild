# Copyright 2019-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

FONTDIR_BIN=( fonts/static/{o,t}tfs )
MY_PN="${PN^}"
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/kosbarts/${MY_PN}.git"
else
	MY_PV="168a0b3"
	[[ -n ${PV%%*_p*} ]] && MY_PV="${PV}"
	SRC_URI="
		mirror://githubcl/kosbarts/${MY_PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	KEYWORDS="~amd64 ~x86"
	RESTRICT="primaryuri"
	S="${WORKDIR}/${MY_PN}-${MY_PV}"
fi
inherit fontmake

DESCRIPTION="A low-contrast humanist sans-serif with almost classical proportions"
HOMEPAGE="https://github.com/kosbarts/${MY_PN}"

LICENSE="OFL-1.1"
SLOT="0"
BDEPEND="
	binary? ( app-arch/unzip )
"
REQUIRED_USE+="
	binary? ( variable? ( !font_types_otf ) )
"

pkg_setup() {
	use variable && FONTDIR_BIN=( fonts/variable )
	fontmake_pkg_setup
}
