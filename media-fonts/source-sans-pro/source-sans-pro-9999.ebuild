# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..11} )
MY_FONT_TYPES=( otf +ttf )
MY_PN=${PN%-pro}
if [[ ${PV} == *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/adobe-fonts/${MY_PN}"
else
	MY_PV="93fc257"
	MY_PVB="5b44992"
	if [[ -n ${PV%%*_p*} ]]; then
		MY_PV="${PV}"
		MY_PVB="${MY_PV}R"
	fi
	SRC_URI="https://github.com/adobe-fonts/${MY_PN}/releases/download/${MY_PVB}/"
	SRC_URI="
		binary? (
			variable? ( ${SRC_URI}VF-${MY_PN}-${MY_PVB}.zip )
			!variable? (
				font_types_otf? ( ${SRC_URI}OTF-${MY_PN}-${MY_PVB}.zip )
				font_types_ttf? ( ${SRC_URI}TTF-${MY_PN}-${MY_PVB}.zip )
			)
		)
		!binary? (
			mirror://githubcl/adobe-fonts/${MY_PN}/tar.gz/${MY_PV}
			-> ${P}.tar.gz
		)
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi
inherit python-any-r1 font-r1

DESCRIPTION="Sans serif font family for user interface environments"
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
		S="${S%/*}/$(usex binary '' ${MY_PN}-${MY_PV})"
	fi
	FONT_S=( $(usex binary . target)/$(usex variable VF $(usex font_types_otf OTF TTF)) )
	font-r1_pkg_setup
	use binary || python-any-r1_pkg_setup
}

src_prepare() {
	default
	use binary && return
	sed -e "s:/tmp/:${T}/:g" -i buildVFs.py
	local _d _n=glyphs.com.adobe.type.processedGlyphs
	find -type d -name ${_n} | while read _d; do
		mv "${_d}"/*.* "${_d/G/g}"
	done
}

src_compile() {
	use binary && return
	if use variable; then
		${EPYTHON} ./buildVFs.py || die
	else
		sh ./build.sh || die
	fi
}
