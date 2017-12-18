# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

MY_FONT_TYPES=( ttc +ttf )
MY_FONT_VARIANTS=( cc slab )
inherit font-r1

DESCRIPTION="A CJK monospaced font, a composite of Iosevka, M+ and Source Han Sans"
HOMEPAGE="https://be5invis.github.io/${PN^}"
SRC_URI="https://github.com/be5invis/Iosevka/releases/download/v${PV}/"
SRC_URI="
	font_types_ttc? ( ${SRC_URI}${P}.7z )
	font_types_ttf? ( ${SRC_URI}${PN}-ttfs-${PV}.7z )
"
RESTRICT="primaryuri"

LICENSE="OFL-1.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="l10n_ja l10n_ko l10n_zh-CN l10n_zh-TW"
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
	rm -f \
		$(usex !l10n_ja "${PN}*-J-*.tt[cf]") \
		$(usex !l10n_ko "${PN}*-CL-*.tt[cf]") \
		$(usex !l10n_zh-CN "${PN}*-SC-*.tt[cf]") \
		$(usex !l10n_zh-TW "${PN}*-TC-*.tt[cf]") \
		$(usex !font_variants_cc "${PN}CC-*.ttf") \
		$(usex !font_variants_slab "${PN}*-slab-*.ttf") \
		inziu-roboto*.ttf
}
