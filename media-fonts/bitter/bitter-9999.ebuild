# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/solmatas/${PN}.git"
else
	inherit vcs-snapshot
	MY_PV="34686a6"
	[[ -n ${PV%%*_p*} ]] && MY_PV="v.${PV}"
	SRC_URI="
		mirror://githubcl/solmatas/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	KEYWORDS="~amd64 ~x86"
fi
inherit fontmake

DESCRIPTION="A contemporary slab serif typeface for text"
HOMEPAGE="https://huertatipografica.com/en/fonts/bitter-ht"

LICENSE="OFL-1.1"
SLOT="0"
