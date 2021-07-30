# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_FONT_TYPES=( otf +ttf )
MY_PN="${PN%-pro}"
if [[ ${PV} == *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/adobe-fonts/${MY_PN}"
else
	MY_PVB="c811345"
	MY_PV="f90adc0"
	if [[ -n ${PV%%*_p*} ]]; then
		MY_PV="${PV}"
		MY_PVB="${MY_PV}R"
	fi
	SRC_URI="
		binary? (
			mirror://githubcl/adobe-fonts/${MY_PN}/tar.gz/${MY_PVB}
			-> ${P}R.tar.gz
		)
		!binary? (
			mirror://githubcl/adobe-fonts/${MY_PN}/tar.gz/${MY_PV}
			-> ${P}.tar.gz
		)
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi
inherit font-r1

DESCRIPTION="Serif typeface designed to complement Source Sans Pro"
HOMEPAGE="https://adobe-fonts.github.io/${MY_PN}"

LICENSE="OFL-1.1"
SLOT="0"
IUSE="+binary variable"

BDEPEND="
	!binary? (
		dev-util/afdko
		variable? ( dev-util/fontmake )
	)
"

pkg_setup() {
	if [[ ${PV} == *9999* ]]; then
		EGIT_BRANCH="$(usex binary release master)"
	else
		S="${S%/*}/${MY_PN}-$(usex binary ${MY_PVB} ${MY_PV})"
	fi
	FONT_S=( $(usex binary . target)/$(usex variable VAR $(usex font_types_otf OTF TTF)) )
	font-r1_pkg_setup
}

src_compile() {
	use binary && return
	. ./build$(usex variable 'VFs' '').sh || die
}
