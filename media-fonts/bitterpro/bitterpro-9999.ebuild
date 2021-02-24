# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PN="BitterPro"
EMAKE_EXTRA_ARGS=( glyphs='sources/Bitter-Italic.designspace sources/Bitter-Roman.designspace' )
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/solmatas/${MY_PN}.git"
else
	MY_PV="8eab426"
	[[ -n ${PV%%*_p*} ]] && MY_PV="v${PV}"
	SRC_URI="
		mirror://githubcl/solmatas/${MY_PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/${MY_PN}-${MY_PV#v}"
fi
inherit fontmake

DESCRIPTION="A contemporary slab serif typeface for text"
HOMEPAGE="https://github.com/solmatas/${MY_PN}"

LICENSE="OFL-1.1"
SLOT="0"
REQUIRED_USE+="
	binary? ( variable? ( !font_types_otf ) )
"

pkg_setup() {
	use variable && FONTDIR_BIN=( fonts/variable )
	fontmake_pkg_setup
}
