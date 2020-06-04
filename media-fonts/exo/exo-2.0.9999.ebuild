# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_FONT_TYPES=( +otf ttf )
FONTDIR_BIN=( . )
SLOT="${PV:0:3}"
FONT_PN="${PN}-${SLOT}"
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/NDISCOVER/${FONT_PN}.git"
	REQUIRED_USE="!binary"
else
	MY_PV="6ce85fd"
	SRC_URI="
	binary? (
		https://ndiscovered.com/archives/${FONT_PN%.*}.zip
	)
	!binary? (
		mirror://githubcl/NDISCOVER/${FONT_PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	)
	"
	KEYWORDS="~amd64 ~x86"
	REQUIRED_USE="binary? ( !font_types_ttf )"
	S="${WORKDIR}/${PN^}-${SLOT}-${MY_PV}"
fi
inherit fontmake

DESCRIPTION="A geometric sans serif font family"
HOMEPAGE="https://www.ndiscovered.com"

LICENSE="OFL-1.1"

pkg_setup() {
	use binary && S="${WORKDIR}"
	fontmake_pkg_setup
}
