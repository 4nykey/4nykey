# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PN="Inconsolata-LGC"
FONT_SRCDIR=.
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/glebd/${MY_PN}.git"
	EGIT_BRANCH="tight"
	REQUIRED_USE="!binary"
else
	MY_PV="0cdee8c"
	MY_PVB="${PV%_p*}"
	MY_P="${MY_PN/-}-OT-${MY_PVB}"
	SRC_URI="
	binary? (
		font_types_otf? (
			https://github.com/MihailJP/${MY_PN}/releases/download/LGC-${MY_PVB}/${MY_P}.tar.xz
		)
		font_types_ttf? (
			https://github.com/MihailJP/${MY_PN}/releases/download/LGC-${MY_PVB}/${MY_P/-OT}.tar.xz
		)
	)
	!binary? (
		mirror://githubcl/glebd/${MY_PN}/tar.gz/${MY_PV}
		-> ${P}.tar.gz
	)
	"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/${MY_PN}-${MY_PV}"
fi
inherit fontmake

DESCRIPTION="A version of Inconsolata with Greek and Cyrillic support"
HOMEPAGE="https://github.com/MihailJP/${MY_PN}"

LICENSE="OFL-1.1"
SLOT="0"

pkg_setup() {
	if use binary; then
		S="${WORKDIR}"
		FONTDIR_BIN=( ${MY_P} ${MY_P/-OT} )
		DOCS="*/ChangeLog */README"
	fi
	fontmake_pkg_setup
}
