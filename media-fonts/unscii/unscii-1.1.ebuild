# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

MY_FONT_TYPES=( otf +pcf ttf )
MY_FONT_VARIANTS=( alt fantasy mcr tall thin )
inherit toolchain-funcs font-r1

DESCRIPTION="A bitmapped Unicode font based on classic system fonts"
HOMEPAGE="http://pelulamu.net/${PN}/"
SRC_URI="
	${HOMEPAGE}${P}-src.tar.gz
	binary? (
		unicode? (
			font_types_otf? ( ${HOMEPAGE}${PN}-16-full.otf )
			font_types_pcf? ( ${HOMEPAGE}${PN}-16-full.pcf )
			font_types_ttf? ( ${HOMEPAGE}${PN}-16-full.ttf )
		)
		!unicode? (
			font_types_otf? ( ${HOMEPAGE}${PN}-16.otf )
			font_types_pcf? ( ${HOMEPAGE}${PN}-16.pcf )
			font_types_ttf? ( ${HOMEPAGE}${PN}-16.ttf )
		)
		font_types_otf? (
			${HOMEPAGE}${PN}-8.otf
			font_variants_alt? ( ${HOMEPAGE}${PN}-8-alt.otf )
			font_variants_fantasy? ( ${HOMEPAGE}${PN}-8-fantasy.otf )
			font_variants_mcr? ( ${HOMEPAGE}${PN}-8-mcr.otf )
			font_variants_tall? ( ${HOMEPAGE}${PN}-8-tall.otf )
			font_variants_thin? ( ${HOMEPAGE}${PN}-8-thin.otf )
		)
		font_types_pcf? (
			${HOMEPAGE}${PN}-8.pcf
			font_variants_alt? ( ${HOMEPAGE}${PN}-8-alt.pcf )
			font_variants_fantasy? ( ${HOMEPAGE}${PN}-8-fantasy.pcf )
			font_variants_mcr? ( ${HOMEPAGE}${PN}-8-mcr.pcf )
			font_variants_tall? ( ${HOMEPAGE}${PN}-8-tall.pcf )
			font_variants_thin? ( ${HOMEPAGE}${PN}-8-thin.pcf )
		)
		font_types_ttf? (
			${HOMEPAGE}${PN}-8.ttf
			font_variants_alt? ( ${HOMEPAGE}${PN}-8-alt.ttf )
			font_variants_fantasy? ( ${HOMEPAGE}${PN}-8-fantasy.ttf )
			font_variants_mcr? ( ${HOMEPAGE}${PN}-8-mcr.ttf )
			font_variants_tall? ( ${HOMEPAGE}${PN}-8-tall.ttf )
			font_variants_thin? ( ${HOMEPAGE}${PN}-8-thin.ttf )
		)
	)
"
RESTRICT="primaryuri"

LICENSE="OFL-1.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+binary unicode utils"

RDEPEND="
	utils? ( media-libs/sdl-image )
"
DEPEND="
	${RDEPEND}
	!binary? (
		dev-lang/perl
		font_types_otf? ( media-gfx/fontforge )
		font_types_ttf? ( media-gfx/fontforge )
		font_types_pcf? ( x11-apps/bdftopcf )
		unicode? (
			media-fonts/unifont[utils]
		)
	)
	utils? ( dev-lang/perl )
"
S="${WORKDIR}/${P}-src"
DOCS=( ${PN}.txt )

src_unpack() {
	unpack ${P}-src.tar.gz
	use binary && cp -L "${DISTDIR}"/*.*f "${S}"
}

src_prepare() {
	default
	use binary && return
	use unicode && cp "${EROOT}"usr/share/unifont/unifont.hex "${S}"
	local _t='\<woff\>'
	use font_types_otf || _t+='\|\<otf\>'
	use font_types_ttf || _t+='\|\<ttf\>'
	sed -e "/\(${_t}\)/d" -i makevecfonts.ff
}

src_compile() {
	use utils && emake CC="$(tc-getCC) ${CFLAGS}" bm2uns
	use binary && return
	local _s _v _t=( )
	for _s in ${FONT_SUFFIX}; do
		_s=${_s/otf/ttf}
		_t+=(
			${PN}-8.${_s}
			${PN}-16$(usex unicode '-full' '').${_s}
		)
		for _v in "${MY_FONT_VARIANTS[@]}"; do
			has ${_v} ${USE} && _t+=( ${PN}-8-${_v#font_variants_}.${_s} )
		done
	done
	emake CC="$(tc-getCC) ${CFLAGS}" "${_t[@]}"
}

src_install() {
	font-r1_src_install
	use utils && dobin bm2uns
}
