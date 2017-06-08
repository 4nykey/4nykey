# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

FONT_SRCDIR=.
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/carrois/${PN}.git"
else
	inherit vcs-snapshot
	MY_PV="131a598"
	SRC_URI="
		mirror://githubcl/carrois/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	KEYWORDS="~amd64 ~x86"
fi
inherit fontmake
MY_PV="${PV%.9999}"
MY_PV="${MY_PV%_p*}"
MY_F="28cef3ca070463212a1be193bcac29b8-09ea32e"
SRC_URI+="
!binary? (
	mirror://githubcl/gist/${MY_F%-*}/tar.gz/${MY_F#*-}
	-> ${MY_F}.tar.gz
)
"
RESTRICT="primaryuri"

DESCRIPTION="Firefox OS typeface"
HOMEPAGE="https://carrois.com/typefaces/FiraSans"

LICENSE="OFL-1.1"
SLOT="0"
IUSE="clean-as-you-go doc interpolate"

DEPEND="
	!binary? ( app-arch/unzip )
"
RDEPEND="
	!media-fonts/fira-mono
	!media-fonts/fira-sans
"
DOCS="Fira_*/Fira_*_Version_Log.rtf"

pkg_setup() {
	if use binary; then
		local _s="${MY_PV//./_}" _m="3_2"
		_s=${_s%_p*}
		FONTDIR_BIN=(
		Fira_Sans_${_s:0:3}/Fonts/FiraSans_{OTF,WEB}_${_s//_/}/{Compressed,Condensed,Normal}/{Roman,Italic}
		Fira_Mono_${_m}/Fonts/FiraMono_{OTF,WEB}_${_m//_/}
		)
	fi
	use doc && DOCS+=" Fira_[MS]*_*/PDF/*.pdf"
	fontmake_pkg_setup
}

src_prepare() {
	fontmake_src_prepare
	use binary && return
	unpack ${MY_F}.tar.gz

	local _m=${PN^}MonoUFO_beta3206 _s=${PN^}SansUFO_beta${MY_PV} _d
	_s=${_s//./}
	unpack "${S}"/Fira_UFO_Sources/${PN^}{${_m#${PN^}},${_s#${PN^}}}.zip
	renamexm -s'/ //g' {${_m},${_s}}/*.ufo

	sed \
		-e '/^[^#]/s:\(.*\) \(.*\):s_\\<\1\\>_uni\2_g:' \
		${MY_F}/Fira-glyphsubst > "${S}"/1.sed
	sed -f "${FILESDIR}"/0.sed -f "${S}"/1.sed \
		-i "${S}"/{${_m},${_s}}/${PN^}*.ufo/features.fea
	sed \
		-e 's:breve\.cy:brevecy:g' \
		-e 's:\<uni03A9\><:Omega<:g' \
		-i "${S}"/${_s}/${PN^}*.ufo/features.fea
	sed -f "${FILESDIR}"/2.sed \
		-i "${S}"/${_m}/${PN^}*.ufo/{glyphs/contents,lib}.plist
	sed '/key.*-/s:-:.:' -i "${S}"/${_m}/${PN^}*.ufo/glyphs/contents.plist
	sed '/string.*-/s:-:.:' -i "${S}"/${_m}/${PN^}*.ufo/lib.plist
	sed '/\-\(cy\|greek\)/s:-\(cy\|greek\):.\1:' -i "${S}"/${_m}/${PN^}*.ufo/glyphs/*.glif
	sed \
		-e 's:\<uni037F\>:Yot:' \
		-e '/\<uniF6C3\>/d' \
		-i "${S}"/${_m}/${PN^}*.ufo/features.fea

	mkdir -p {mono,sans,italic}/master_ufo
	mv ${MY_F}/${PN^}Mono.designspace "${_m}"/${PN^}Mono*.ufo mono/master_ufo
	mv ${MY_F}/${PN^}Sans-Italic.designspace "${_s}"/${PN^}Sans-*Italic.ufo italic/master_ufo
	mv ${MY_F}/${PN^}Sans.designspace "${_s}"/${PN^}Sans-*.ufo sans/master_ufo
}
