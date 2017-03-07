# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/googlei18n/noto-fonts"
else
	inherit vcs-snapshot
	MY_P="${PN}-fonts-60aa0da"
	SRC_URI="
		mirror://githubcl/googlei18n/${MY_P%-*}/tar.gz/${MY_P##*-}
		-> ${MY_P}.tar.gz
	"
	S="${WORKDIR}/${MY_P}"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi
inherit font-r1

DESCRIPTION="A font family that aims to support all the world's languages"
HOMEPAGE="http://www.google.com/get/noto"

LICENSE="OFL-1.1"
SLOT="0"
IUSE="cjk emoji pipeline"

DEPEND=""
RDEPEND="
	cjk? ( media-fonts/noto-cjk )
	emoji? ( media-fonts/noto-emoji )
	pipeline? ( media-fonts/noto-source )
	!media-fonts/croscorefonts
"
FONT_S=( hinted )
