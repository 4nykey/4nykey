# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_P="${PN}-1293ec3"
inherit font-r1 vcs-snapshot

DESCRIPTION="A font family that aims to support all the world's languages"
HOMEPAGE="https://www.google.com/get/noto"
SRC_URI="
	mirror://githubcl/googlei18n/${PN}/tar.gz/${MY_P##*-}
	-> ${MY_P}.tar.gz
"
RESTRICT="primaryuri"

LICENSE="OFL-1.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="
	!media-fonts/croscorefonts
"
S="${WORKDIR}/${MY_P}"
FONT_S=( hinted )
