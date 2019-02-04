# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

MY_FONT_TYPES=( ttc +ttf )
MY_FONT_VARIANTS=( gothic +mono term ui )
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
IUSE_L10N=( ja ko zh-CN zh-TW )
IUSE="${IUSE_L10N[@]/#/l10n_}"
REQUIRED_USE="
|| ( l10n_ja l10n_ko l10n_zh-CN l10n_zh-TW )
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
		$(usex !l10n_ja "${PN%-*}*-j-*.ttf") \
		$(usex !l10n_ko "${PN%-*}*-cl-*.ttf") \
		$(usex !l10n_zh-CN "${PN%-*}*-sc-*.ttf") \
		$(usex !l10n_zh-TW "${PN%-*}*-tc-*.ttf")
	local _v
	for _v in "${MY_FONT_VARIANTS[@]/#+/}"; do
		use ${_v} || rm -f ${PN%-*}-${_v#font_variants_}-*.ttf
	done
}
