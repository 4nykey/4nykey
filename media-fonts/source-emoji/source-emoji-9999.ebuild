# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

FONT_SUFFIX=otf
if [[ ${PV} == *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/adobe-fonts/${PN}"
	REQUIRED_USE="!binary"
else
	inherit vcs-snapshot
	SRC_URI="
		binary? (
			https://github.com/adobe-fonts/${PN}/releases/download/${PV}/SourceEmoji-BnW.otf
			-> ${P}.otf
		)
		!binary? (
			mirror://githubcl/adobe-fonts/${PN}/tar.gz/${PV}
			-> ${P}.tar.gz
		)
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi
inherit font-r1

DESCRIPTION="A monochrome emoji font designed to harmonize with other Source fonts"
HOMEPAGE="https://github.com/adobe-fonts/${PN}"

LICENSE="OFL-1.1"
SLOT="0"
IUSE="+binary"

DEPEND="
	!binary? ( dev-util/afdko )
"

pkg_setup() {
	use binary && S="${WORKDIR}"
	font-r1_pkg_setup
}

src_unpack() {
	if [[ ${PV} == *9999* ]]; then
		git-r3_src_unpack
	elif use binary; then
		mv "${DISTDIR}"/${P}.otf "${S}"/
	else
		default
	fi
}

src_compile() {
	use binary && return
	makeotf -f SourceEmoji-BnW.ufo -r || die
}
