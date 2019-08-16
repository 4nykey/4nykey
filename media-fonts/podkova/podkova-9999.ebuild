# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/cyrealtype/${PN}.git"
else
	inherit vcs-snapshot
	MY_PV="ae3de31"
	SRC_URI="
		mirror://githubcl/cyrealtype/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	KEYWORDS="~amd64 ~x86"
fi
inherit fontmake

DESCRIPTION="A monoline slab serif with diagonal terminals"
HOMEPAGE="https://github.com/cyrealtype/${PN}"

LICENSE="OFL-1.1"
SLOT="0"
REQUIRED_USE="binary? ( !font_types_otf )"
