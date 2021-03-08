# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PN="JetBrainsMono"
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/JetBrains/${MY_PN}.git"
else
	MY_PV="108fc51"
	[[ -n ${PV%%*_p*} ]] && MY_PV="v${PV}"
	SRC_URI="
		mirror://githubcl/JetBrains/${MY_PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/${MY_PN}-${MY_PV#v}"
fi
inherit fontmake

DESCRIPTION="A free and open-source typeface for developers"
HOMEPAGE="https://jetbrains.com/mono"

LICENSE="OFL-1.1"
SLOT="0"
REQUIRED_USE+="
	binary? ( variable? ( !font_types_otf ) )
"
PATCHES=( "${FILESDIR}"/italic.diff )

pkg_setup() {
	use variable && FONTDIR_BIN=( fonts/variable )
	fontmake_pkg_setup
}
