# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/googlefonts/${PN}.git"
else
	MY_PV="59745e8"
	[[ -n ${PV%%*_p*} ]] && MY_PV="v${PV/_/-}"
	SRC_URI="
		mirror://githubcl/googlefonts/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/${PN}-${MY_PV#v}"
fi
inherit fontmake

DESCRIPTION="Caveat handwriting fonts"
HOMEPAGE="https://github.com/googlefonts/${PN}"

LICENSE="OFL-1.1"
SLOT="0"
REQUIRED_USE+="
	binary? ( variable? ( !font_types_otf ) )
"

pkg_setup() {
	use variable && FONTDIR_BIN=( fonts/variable )
	fontmake_pkg_setup
}
