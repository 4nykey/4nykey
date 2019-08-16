# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/JulietaUla/${PN}.git"
else
	inherit vcs-snapshot
	MY_PV="49e9a09"
	[[ -n ${PV%%*_p*} ]] && MY_PV="v${PV}"
	SRC_URI="
		mirror://githubcl/JulietaUla/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	KEYWORDS="~amd64 ~x86"
fi
inherit fontmake

DESCRIPTION="A typeface inspired by the Montserrat neighborhood of Buenos Aires"
HOMEPAGE="https://github.com/JulietaUla/${PN}"

LICENSE="OFL-1.1"
SLOT="0"
PATCHES=( ${FILESDIR}/${PN}-layer_name.diff )
