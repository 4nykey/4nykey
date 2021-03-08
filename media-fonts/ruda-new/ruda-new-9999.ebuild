# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PN="${PN^}"
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/TypeNetwork/${MY_PN}.git"
else
	MY_PV="381d3c0"
	SRC_URI="
		mirror://githubcl/TypeNetwork/${MY_PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/${MY_PN}-${MY_PV#v}"
fi
inherit fontmake

DESCRIPTION="Ruda Cyrillic Latin expanded with turkish"
HOMEPAGE="https://github.com/TypeNetwork/${MY_PN}"

LICENSE="OFL-1.1"
SLOT="0"
REQUIRED_USE+="
	binary? ( variable? ( !font_types_otf ) )
"

pkg_setup() {
	use variable && FONTDIR_BIN=( fonts/vf )
	fontmake_pkg_setup
}
