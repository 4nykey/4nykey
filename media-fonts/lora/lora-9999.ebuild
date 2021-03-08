# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

EMAKE_EXTRA_ARGS=( glyphs='sources/Lora-Italic.designspace sources/Lora.designspace' )
MY_PN="${PN^}-Cyrillic"
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/cyrealtype/${MY_PN}.git"
else
	MY_PV="aa7bfd1"
	[[ -n ${PV%%*_p*} ]] && MY_PV="v${PV}"
	SRC_URI="
		mirror://githubcl/cyrealtype/${MY_PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/${MY_PN}-${MY_PV#v}"
fi
inherit fontmake

DESCRIPTION="A well-balanced contemporary serif with roots in calligraphy"
HOMEPAGE="https://github.com/cyrealtype/${PN}"

LICENSE="OFL-1.1"
SLOT="0"
REQUIRED_USE+="
	binary? ( variable? ( !font_types_otf ) )
"

pkg_setup() {
	use variable && FONTDIR_BIN=( fonts/vf )
	fontmake_pkg_setup
}
