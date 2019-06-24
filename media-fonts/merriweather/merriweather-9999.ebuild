# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

FONTDIR_BIN=( fonts/{otf,ttfs} )
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/SorkinType/${PN}.git"
else
	inherit vcs-snapshot
	MY_PV="4fd88c9"
	[[ -n ${PV%%*_p*} ]] && MY_PV="v${PV}"
	SRC_URI="
		mirror://githubcl/SorkinType/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	KEYWORDS="~amd64 ~x86"
fi
inherit fontmake

DESCRIPTION="A serif font useful for creating long texts for books or articles"
HOMEPAGE="https://github.com/SorkinType/${PN}"

LICENSE="OFL-1.1"
SLOT="0"
