# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_FONT_TYPES=( +ttc ttf )
MY_FONT_VARIANTS=( fixed +monospace sans slab term ui )
inherit unpacker font-r1

DESCRIPTION="A CJK programming font based on Iosevka and Source Han Sans"
HOMEPAGE="https://github.com/be5invis/${PN}"
MY_PV=$(ver_rs 3 '-' 4 '.')
MY_PN=Sarasa
SRC_URI="https://github.com/be5invis/${PN}/releases/download/v${MY_PV}/"
SRC_URI="
autohint? (
	font_types_ttc? ( ${SRC_URI}${MY_PN}-SuperTTC-${MY_PV%_*}.7z )
	font_types_ttf? ( ${SRC_URI}${MY_PN}-TTF-${MY_PV%_*}.7z )
)
!autohint? (
	font_types_ttc? ( ${SRC_URI}${MY_PN}-SuperTTC-Unhinted-${MY_PV%_*}.7z )
	font_types_ttf? ( ${SRC_URI}${MY_PN}-TTF-Unhinted-${MY_PV%_*}.7z )
)
"
RESTRICT="primaryuri"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE_L10N=( ja ko zh-CN zh-HK zh-TW )
IUSE_L10N="${IUSE_L10N[@]/#/l10n_}"
IUSE="autohint classical ${IUSE_L10N}"
REQUIRED_USE="
font_types_ttf? (
	|| (
		classical
		|| ( ${IUSE_L10N} )
	)
	|| ( ${MY_FONT_VARIANTS[@]/#+/} )
)
?? ( ${MY_FONT_TYPES[@]/#+/} )
"
S="${WORKDIR}"

src_prepare() {
	default
	use font_types_ttc && return
	local _l=(
		$(usex !font_variants_slab "${MY_PN%-*}*Slab*.ttf")
		$(usex !font_variants_fixed "${MY_PN%-*}*Fixed*.ttf")
		$(usex !font_variants_monospace "${MY_PN%-*}*Mono*.ttf")
		$(usex !font_variants_sans "${MY_PN%-*}*Gothic*.ttf")
		$(usex !font_variants_term "${MY_PN%-*}*Term*.ttf")
		$(usex !font_variants_ui "${MY_PN%-*}*Ui*.ttf")
	)
	if use classical; then
		_l+=( ${MY_PN%-*}*{J,K,SC,HC,TC}-*.ttf )
	else
		_l+=(
		${MY_PN%-*}*-cl-*.ttf
		$(usex !l10n_ja "${MY_PN%-*}*J-*.ttf")
		$(usex !l10n_ko "${MY_PN%-*}*K-*.ttf")
		$(usex !l10n_zh-CN "${MY_PN%-*}*SC-*.ttf")
		$(usex !l10n_zh-HK "${MY_PN%-*}*HC-*.ttf")
		$(usex !l10n_zh-TW "${MY_PN%-*}*TC-*.ttf")
		)
	fi
	rm -f "${_l[@]}"
}
