# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_FONT_TYPES=( +otf ttf )
SLOT="0"
MY_PN="${PN^}-2.0"
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/NDISCOVER/${MY_PN}.git"
else
	MY_PV="182060c"
	SRC_URI="
		mirror://githubcl/NDISCOVER/${MY_PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/${MY_PN}-${MY_PV}"
fi
inherit fontmake

DESCRIPTION="A geometric sans serif font family"
HOMEPAGE="https://www.ndiscover.com/exo-2-0"

LICENSE="OFL-1.1"
REQUIRED_USE="
	binary? ( variable? ( !font_types_otf ) )
"
RDEPEND="!media-fonts/exo:2.0"

pkg_setup() {
	use variable && FONTDIR_BIN=( fonts/variable )
	fontmake_pkg_setup
}
