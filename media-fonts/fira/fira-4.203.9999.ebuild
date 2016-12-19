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
	KEYWORDS="~amd64 ~x86"
fi
inherit python-any-r1 font-r1
MY_MK="9ef5512cdd3177cc8d4667bcf5a58346-355c7d9"
MY_F="28cef3ca070463212a1be193bcac29b8-4ce7076"
SRC_URI+="
!binary? (
	mirror://githubcl/gist/${MY_MK%-*}/tar.gz/${MY_MK#*-}
	-> ${MY_MK}.tar.gz
	mirror://githubcl/gist/${MY_F%-*}/tar.gz/${MY_F#*-}
	-> ${MY_F}.tar.gz
)
"
RESTRICT="primaryuri"

DESCRIPTION="Firefox OS typeface"
HOMEPAGE="https://carrois.com/typefaces/FiraSans"

LICENSE="OFL-1.1"
SLOT="0"
IUSE="clean-as-you-go +binary doc interpolate"

DEPEND="
	!binary? (
		${PYTHON_DEPS}
		$(python_gen_any_dep '
			dev-util/fontmake[${PYTHON_USEDEP}]
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
		FONT_S=( master_{o,t}tf )
	fi
	use doc && DOCS+=" Fira_[MS]*_*/PDF/*.pdf"
	font-r1_pkg_setup
}

src_prepare() {
	default
	use binary && return
	unpack ${MY_F}.tar.gz ${MY_MK}.tar.gz

	local _m=${PN^}MonoUFO_beta3206 _s=${PN^}SansUFO_beta${PV%.9999} _d
	_s=${_s//./}
	unpack "${S}"/Fira_UFO_Sources/${PN^}{${_m#${PN^}},${_s#${PN^}}}.zip
	for _d in "${S}"/{${_m},${_s}}/*.ufo; do
		mv -f "${_d}" "${_d// /}"
	done

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

	mv ${MY_F}/FiraMono.designspace ${_m}/
	mv ${MY_F}/FiraSans*.designspace ${_s}/

}

src_compile() {
	use binary && return
	emake \
		SRCDIR="${S}" \
		FONTMAKE="fontmake -o ${FONT_SUFFIX}" \
		$(usex interpolate '' 'INTERPOLATE=') \
		$(usex clean-as-you-go 'RM=rm -rf' '') \
		-f ${MY_MK}/Makefile.ds
}
