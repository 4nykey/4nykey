# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="${PN^}"
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/SorkinType/${MY_PN}.git"
else
	MY_PV="7614879"
	[[ -n ${PV%%*_p*} ]] && MY_PV="v${PV}"
	SRC_URI="
		mirror://githubcl/SorkinType/${MY_PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	KEYWORDS="~amd64"
	S="${WORKDIR}/${MY_PN}-${MY_PV#v}"
fi
inherit fontmake

DESCRIPTION="A serif font useful for creating long texts for books or articles"
HOMEPAGE="https://github.com/SorkinType/${MY_PN}"

LICENSE="OFL-1.1"
SLOT="0"
REQUIRED_USE="
	binary? (
		variable? ( !font_types_otf )
	)
"

pkg_setup() {
	use variable && FONTDIR_BIN=( fonts/variable )
	fontmake_pkg_setup
}
