# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

FONT_TYPES="otf ttf"
PYTHON_COMPAT=( python2_7 )
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/carrois/${PN}.git"
else
	inherit vcs-snapshot
	MY_PV="131a598"
	SRC_URI="
		mirror://githubcl/carrois/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi
inherit python-any-r1 font-r1
MY_MK="f9edc47e189d8495b647a4feac8ca240-1827636"
SRC_URI+="
!binary? (
	mirror://githubcl/gist/${MY_MK%-*}/tar.gz/${MY_MK#*-}
	-> ${MY_MK}.tar.gz
)
"

DESCRIPTION="Firefox OS typeface"
HOMEPAGE="https://carrois.com/typefaces/FiraSans"

LICENSE="OFL-1.1"
SLOT="0"
IUSE="+binary doc"

DEPEND="
	!binary? (
		${PYTHON_DEPS}
		$(python_gen_any_dep '
			media-gfx/fontforge[python,${PYTHON_USEDEP}]
		')
		app-arch/unzip
	)
"
RDEPEND="
	!media-fonts/fira-mono
	!media-fonts/fira-sans
"
DOCS+=" Fira_*/Fira_*_Version_Log.rtf"

pkg_setup() {
	if use binary; then
		local _s="${PV//./_}" _m="3_2"
		_s=${_s%_p*}
		FONT_S=(
		Fira_Sans_${_s:0:3}/Fonts/FiraSans_{OTF,WEB}_${_s//_/}/{Compressed,Condensed,Normal}/{Roman,Italic}
		Fira_Mono_${_m}/Fonts/FiraMono_{OTF,WEB}_${_m//_/}
		)
	else
		python-any-r1_pkg_setup
	fi
	use doc && DOCS+=" Fira_[MS]*_*/PDF/*.pdf"
	font-r1_pkg_setup
}

src_prepare() {
	default
	use binary && return
	unpack ${MY_MK}.tar.gz
	local _m=MonoUFO_beta3206 _s=SansUFO_beta${PV%.9999}
	unpack "${S}"/Fira_UFO_Sources/Fira{${_m},${_s//./}}.zip
}

src_compile() {
	use binary && return
	local _t _u
	for _u in Fira{Sans,Mono}UFO_*/*.ufo; do
	for _t in ${FONT_SUFFIX}; do
		fontforge -script ${MY_MK}/ffgen.py "${_u}" ${_t} || die
	done
	done
}
