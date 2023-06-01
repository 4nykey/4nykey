# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..11} )
MY_FONT_TYPES=( +otf ttf )
if [[ ${PV} == *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/adobe-fonts/${PN}"
else
	MY_PVB="678cc31"
	MY_PV="024350a"
	if [[ -n ${PV%%*_p*} ]]; then
		MY_PV="${PV}-u/1.062-i/1.026-vf"
		MY_PVB="${MY_PV//-/R-}"
	fi
	SRC_URI="https://github.com/adobe-fonts/${PN}/releases/download/${MY_PVB}/"
	MY_PVB="${MY_PVB//\//_}"
	MY_PVB="${MY_PVB//-vf/vf}"
	MY_PVB="${MY_PVB//i_*/i}"
	SRC_URI="
		binary? (
			variable? ( ${SRC_URI}VF-source-code-VF-1.026R.zip )
			!variable? (
				font_types_otf? ( ${SRC_URI}OTF-${PN}-${MY_PVB}.zip )
				font_types_ttf? ( ${SRC_URI}TTF-${PN}-${MY_PVB}.zip )
			)
		)
		!binary? (
			mirror://githubcl/adobe-fonts/${PN}/tar.gz/${MY_PV}
			-> ${P}.tar.gz
		)
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64"
fi
inherit python-any-r1 font-r1

DESCRIPTION="Monospaced font family for user interface and coding environments"
HOMEPAGE="https://adobe-fonts.github.io/${PN}"

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
		S="${S%/*}/$(usex binary '' ${PN}-${MY_PV//\//-})"
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
		mv "${_d}" "${_d/G/g}"
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
