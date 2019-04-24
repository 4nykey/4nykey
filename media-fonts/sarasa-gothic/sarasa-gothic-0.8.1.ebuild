# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

MY_FONT_TYPES=( ttc +ttf )
MY_FONT_VARIANTS=( sans +monospace term ui )
inherit font-r1

DESCRIPTION="A CJK programming font based on Iosevka and Source Han Sans"
HOMEPAGE="https://github.com/be5invis/${PN}"
SRC_URI="https://github.com/be5invis/${PN}/releases/download/v${PV/_/-}/"
SRC_URI="
	font_types_ttc? ( ${SRC_URI}${PN}-ttc-${PV%_*}.7z )
	font_types_ttf? ( ${SRC_URI}${PN}-ttf-${PV%_*}.7z )
"
RESTRICT="primaryuri"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE_L10N=( ja zh-CN zh-HK zh-TW )
IUSE="${IUSE_L10N[@]/#/l10n_}"
REQUIRED_USE="
font_types_ttf? ( || ( ${IUSE} ) )
?? ( ${MY_FONT_TYPES[@]/#+/} )
"
DEPEND="
	app-arch/p7zip
"
S="${WORKDIR}"

src_prepare() {
	default
	use font_types_ttc && return
	rm -f \
		${PN%-*}-monoT-*.ttf \
		${PN%-*}*-cl-*.ttf \
		$(usex !l10n_ja "${PN%-*}*-j-*.ttf") \
		$(usex !l10n_zh-CN "${PN%-*}*-sc-*.ttf") \
		$(usex !l10n_zh-HK "${PN%-*}*-hc-*.ttf") \
		$(usex !l10n_zh-TW "${PN%-*}*-tc-*.ttf") \
		$(usex !font_variants_sans "${PN%-*}-gothic-*.ttf") \
		$(usex !font_variants_monospace "${PN%-*}-mono-*.ttf") \
		$(usex !font_variants_term "${PN%-*}-term-*.ttf") \
		$(usex !font_variants_ui "${PN%-*}-ui-*.ttf")
}
