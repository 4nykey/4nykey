# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_FONT_TYPES=( otf +ttf )
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/${PN}/${PN}.git"
else
	inherit vcs-snapshot
	MY_PV="affe57d"
	[[ -n ${PV%%*_p*} ]] && MY_PV="${PV}"
	SRC_URI="
		mirror://githubcl/${PN}/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi
inherit font-r1

DESCRIPTION="An open source geometric sans-serif font based on URW Gothic L"
HOMEPAGE="https://evolventa.github.io"

LICENSE="|| ( GPL-2 LPPL-1.3c )"
SLOT="0"
IUSE="+binary doc"

DEPEND="
	!binary? (
		media-gfx/fontforge
		font_types_ttf? ( media-gfx/ttfautohint )
		doc? (
			virtual/latex-base
			app-text/fntsample
		)
	)
"
FONT_S=( otf ttf )
DOCS=(
README.md
doc/manual/manual.pdf
doc/coverage/Evolventa-{BoldOblique,Bold,Oblique,Regular}.pdf
)

src_compile() {
	use binary && return
	emake -C src ${FONT_SUFFIX}
	if use doc; then
		emake -C src coverage
		touch doc/manual/manual.tex
		emake -C doc/manual manual.pdf
	fi
}
