# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

FONT_TYPES=( +otf ttf )
FONTDIR_BIN=( . )
inherit versionator
SLOT="$(get_version_component_range 1-2)"
FONT_PN="${PN}-${SLOT}"
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/NDISCOVER/${FONT_PN}.git"
	REQUIRED_USE="!binary"
else
	inherit vcs-snapshot
	MY_PV="1689ebf"
	SRC_URI="
	binary? (
		http://www.ndiscovered.com/downloads/${PN}${SLOT%.*}/${PN^^}_${SLOT%.*}_OTF.zip
	)
	!binary? (
		mirror://githubcl/NDISCOVER/${FONT_PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	)
	"
	KEYWORDS="~amd64 ~x86"
	REQUIRED_USE="binary? ( !font_types_ttf )"
fi
inherit fontmake

DESCRIPTION="A geometric sans serif font family"
HOMEPAGE="http://www.ndiscovered.com/${FONT_PN%.*}"

LICENSE="OFL-1.1"

pkg_setup() {
	if use binary; then
		S="${WORKDIR}"
	else
		myemakeargs=( SRCDIR=Source )
		PATCHES=(
			"${FILESDIR}"/${PN}${SLOT}_italic.diff
		)
	fi
	fontmake_pkg_setup
}
