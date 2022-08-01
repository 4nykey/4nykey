# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

FONTDIR_BIN=( fonts/desktop{,_otf} fonts/sc{,_otf} )
MY_FONT_VARIANTS=( smallcaps )
MY_PN="${PN^}"
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/productiontype/${MY_PN}.git"
else
	MY_PV="748733e"
	SRC_URI="
		mirror://githubcl/productiontype/${MY_PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/${MY_PN}-${MY_PV}"
fi
inherit fontmake

DESCRIPTION="A serif typeface for text-rich, screen-first environments and long-form reading"
HOMEPAGE="https://productiontype.github.io/${MY_PN}"

LICENSE="OFL-1.1"
SLOT="0"
DOCS=( contributors.txt )
PATCHES=( "${FILESDIR}"/openTypeOS2WeightClass.diff )
