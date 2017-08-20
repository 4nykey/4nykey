# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/chuckmasterson/${PN}.git"
else
	inherit vcs-snapshot
	MY_PV="423d734"
	SRC_URI="
		mirror://githubcl/chuckmasterson/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi
inherit font-r1
MY_MK="f9edc47e189d8495b647a4feac8ca240-1827636"
SRC_URI+="
	mirror://githubcl/gist/${MY_MK%-*}/tar.gz/${MY_MK#*-}
	-> ${MY_MK}.tar.gz
"

DESCRIPTION="A multilingual serif font with banner-shaped finials and airy letterforms"
HOMEPAGE="http://looseleaf.chuckmasterson.com/walleye"

LICENSE="OFL-1.1"
SLOT="0"
IUSE="+binary"

DEPEND="
	!binary? (
		media-gfx/fontforge
	)
"
FONT_SUFFIX="otf"

src_prepare() {
	default
	use binary || unpack ${MY_MK}.tar.gz
}

src_compile() {
	if use binary; then
		mv usable-otf-files/${PN^}*.otf .
	else
		local _u
		for _u in "${S}"/ufo-files/${PN^}*.ufo; do
			fontforge -script ${MY_MK}/ffgen.py "${_u}" ${FONT_SUFFIX}
		done
	fi
}
