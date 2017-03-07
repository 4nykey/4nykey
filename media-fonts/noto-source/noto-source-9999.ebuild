# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

FONT_TYPES=( otf +ttf )
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/googlei18n/${PN}"
else
	inherit vcs-snapshot
	MY_PV="b454a53"
	MY_PVB="60aa0da"
	SRC_URI="
	!binary? (
		mirror://githubcl/googlei18n/${PN}/tar.gz/${MY_PV}
		-> ${P}.tar.gz
	)
	binary? (
		mirror://githubcl/googlei18n/noto-fonts/tar.gz/${MY_PVB}
		-> noto-fonts-${MY_PVB}.tar.gz
	)
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi
inherit fontmake

DESCRIPTION="A WIP versions of the noto fonts"
HOMEPAGE="https://github.com/googlei18n/${PN}"

LICENSE="OFL-1.1"
SLOT="0"
IUSE="clean-as-you-go interpolate"

pkg_setup() {
	if use binary; then
		EGIT_REPO_URI="https://github.com/googlei18n/noto-fonts"
		FONTDIR_BIN=( alpha/from-pipeline/unhinted/{o,t}tf/s{ans,erif} )
		[[ -n ${PV%%*9999} ]] && S="${WORKDIR}/noto-fonts-${MY_PVB}"
	else
		myemakeargs=(
			$(usex interpolate '' 'INTERPOLATE=')
			$(usex clean-as-you-go 'CLEAN=y' '')
		)
	fi
	fontmake_pkg_setup
}

src_prepare() {
	fontmake_src_prepare
	use binary || \
	ln -s "${S}"/src/NotoSansDevanagari/NotoSansDevanagari{,UI}-MM.glyphs
}
