# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

FONT_TYPES=( otf +ttf )
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/skosch/${PN}.git"
else
	inherit vcs-snapshot
	MY_PV="db93dca"
	SRC_URI="
		mirror://githubcl/skosch/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi
MY_MK="f9edc47e189d8495b647a4feac8ca240-1827636"
SRC_URI+="
	mirror://githubcl/gist/${MY_MK%-*}/tar.gz/${MY_MK#*-}
	-> ${MY_MK}.tar.gz
"
inherit font-r1

DESCRIPTION="A free and open-source text type family"
HOMEPAGE="https://github.com/skosch/${PN}"

LICENSE="OFL-1.1"
SLOT="0"
IUSE="+binary"

DEPEND="
	!binary? (
		sys-devel/bmake
		media-gfx/fontforge
	)
"
FONT_S=( Desktop\ Fonts/{O,T}TF )

src_prepare() {
	default
	use binary || sed -e '/EXTS+=/d' -i "${S}"/Makefile
}

src_compile() {
	use binary && return
	bmake EXTS="${FONT_SUFFIX}" mergefea all || die
}
