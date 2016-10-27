# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

MY_IN="Inconsolata-c57f86c" #20161013 https://github.com/cyrealtype/Inconsolata
MY_MP="mplus-TESTFLIGHT-062" #20160930 https://osdn.net/projects/mplus-fonts/releases/62344
MY_IP="ipag00303"
FONT_SUFFIX="ttf"
S="${WORKDIR}"
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/cyrealtype/Inconsolata.git"
else
	SRC_URI="
		http://www.rs.tus.ac.jp/yyusa/${PN}/${PN}_generator-${PV}.sh
		mirror://githubcl/cyrealtype/${MY_IN%-*}/tar.gz/${MY_IN##*-}
		-> ${MY_IN}.tar.gz
	"
	KEYWORDS="~amd64 ~x86"
fi
inherit font-r1
RESTRICT="primaryuri bindist"

DESCRIPTION="A monotype font combining Inconsolata and Japanese M+/IPA"
HOMEPAGE="http://www.rs.tus.ac.jp/yyusa/ricty.html"
SRC_URI+="
	http://www.rs.tus.ac.jp/yyusa/${PN}/${PN}_discord_converter.pe
	http://www.rs.tus.ac.jp/yyusa/${PN}/regular2oblique_converter.pe
	https://osdn.jp/dl/mplus-fonts/${MY_MP}.tar.xz
	http://dl.ipafont.ipa.go.jp/IPAfont/${MY_IP}.zip
"

LICENSE="OFL-1.1 IPAfont"
SLOT="0"
IUSE=""

DEPEND="
	media-gfx/fontforge
"

src_unpack() {
	unpack ${MY_MP}.tar.xz ${MY_IP}.zip
	local x
	if [[ -z ${PV%%*9999} ]]; then
		wget --no-verbose http://www.rs.tus.ac.jp/yyusa/${PN}/${PN}_generator.sh
		EGIT_CHECKOUT_DIR="${S}/${MY_IN}" git-r3_src_unpack
	else
		cp "${DISTDIR}"/${PN}_generator-${PV}.sh "${S}"/${PN}_generator.sh
		unpack ${MY_IN}.tar.gz
	fi
}

src_prepare() {
	default
	printf 'family = "Migu 1M"\n' > "${S}"/m++ipa.pe
	sed -e '/panose_mono.*=/!d' ${MY_MP}/m++ipa.pe >> "${S}"/m++ipa.pe
	sed \
		-e '/Open(Mplus1m)/,/Close()/!d' \
		-e "s:Mplus1m:\"${MY_MP}/mplus-1m-regular.ttf\":" \
		-e '/SetFontNames(/ s:(family +:("Migu-1M" +:' \
		-e 's:family + ".ttf:"migu-1m-regular.ttf:' \
		-e "s:KanjiFont:\"${MY_IP}/ipag.ttf\":" \
		${MY_MP}/m++ipa.pe > "${T}"/_rgl
	sed \
		-e 's:Regular:Bold:g' \
		-e 's:regular:bold:g' \
		"${T}"/_rgl > "${T}"/_bld
	cat "${T}"/_rgl "${T}"/_bld >> "${S}"/m++ipa.pe
	sed -e 's:\<65551\>:"zero.ss02":' \
		"${DISTDIR}/${PN}_discord_converter.pe" > "${S}"/discord.pe
}

src_compile() {
	fontforge -script "${S}"/m++ipa.pe || die

	sh "${S}"/${PN}_generator.sh \
		"${S}"/${MY_IN}/fonts/ttf/Inconsolata-{Regular,Bold}.ttf \
		"${S}"/migu-1m-{regular,bold}.ttf \
		|| die

	fontforge -script "${S}"/discord.pe -r Ricty*.ttf || die
	fontforge -script "${DISTDIR}"/regular2oblique_converter.pe \
		Ricty*.ttf || die

	rm -f "${S}"/migu-1m-{regular,bold}.ttf
}
