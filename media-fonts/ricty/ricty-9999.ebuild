# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

MY_INC="c6c7e43"
MY_MP="mplus-TESTFLIGHT-061"
MY_IPA="IPAfont00303"
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/seinto1003/${PN}.git"
	ECVS_USER="anonymous"
	REQUIRED_USE="!binary"
else
	SRC_URI="
		binary? (
			http://www.rs.tus.ac.jp/yyusa/${PN}_diminished/${PN}_diminished-${PV}.tar.gz
		)
		!binary? (
			http://www.rs.tus.ac.jp/yyusa/${PN}/${PN}_generator-${PV}.sh
			http://www.rs.tus.ac.jp/yyusa/${PN}/${PN}_discord_converter.pe
		)
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi
inherit font

DESCRIPTION="A monotype font combining Inconsolata and Japanese M+/IPA"
HOMEPAGE="http://www.rs.tus.ac.jp/yyusa/ricty.html"
SRC_URI+="
	!binary? (
		mirror://githubraw/google/fonts/${MY_INC}/ofl/inconsolata/Inconsolata-Regular.ttf
		mirror://githubraw/google/fonts/${MY_INC}/ofl/inconsolata/Inconsolata-Bold.ttf
		http://www.rs.tus.ac.jp/yyusa/${PN}/regular2oblique_converter.pe
		https://osdn.jp/dl/mplus-fonts/${MY_MP}.tar.xz
		http://dl.ipafont.ipa.go.jp/IPAfont/${MY_IPA}.zip
	)
"

LICENSE="BSD-2 OFL-1.1 IPAfont"
SLOT="0"
IUSE="+binary bindist"
REQUIRED_USE+=" bindist? ( binary )"

DEPEND="
	!binary? ( media-gfx/fontforge )
"
RDEPEND=""

FONT_SUFFIX="ttf"
S="${WORKDIR}"
FONT_S="${S}"

src_unpack() {
	[[ -z ${PV%%*9999} ]] && git-r3_src_unpack
	if use binary; then
		unpack ${PN}_diminished-${PV}.tar.gz
	else
		unpack ${MY_MP}.tar.xz ${MY_IPA}.zip
	fi
}

src_prepare() {
	default
	use binary || \
	cp "${WORKDIR}"/${MY_IPA}/ipag.ttf "${FILESDIR}"/m++ipa.pe \
		"${WORKDIR}"/${MY_MP}/
}

src_compile() {
	use binary && return

	local _g="${DISTDIR}/${PN}_generator-${PV}.sh"
	[[ -z ${PV%%*9999} ]] && _g="${WORKDIR}/${P}/${PN}_generator.sh"

	pushd "${WORKDIR}"/${MY_MP}/ > /dev/null
	fontforge -script m++ipa.pe || die
	popd > /dev/null

	sh "${_g}" \
		"${DISTDIR}"/Inconsolata-{Regular,Bold}.ttf \
		"${WORKDIR}"/${MY_MP}/migu-1m-{regular,bold}.ttf \
		|| die

	fontforge -script "${DISTDIR}"/regular2oblique_converter.pe \
		Ricty*.ttf || die

	mv -f Ricty*.ttf "${FONT_S}"/
}
