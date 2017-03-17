# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

FONT_TYPES=( ttc +ttf )
FONT_VARIANTS=( cc slab )
inherit font-r1

DESCRIPTION="A CJK monospaced font, a composite of Iosevka, M+ and Source Han Sans"
HOMEPAGE="https://be5invis.github.io/${PN^}"
SRC_URI="
	font_types_ttc? (
		http://7xpdnl.dl1.z0.glb.clouddn.com/${P}.7z
	)
	font_types_ttf? (
		http://7xpdnl.dl1.z0.glb.clouddn.com/${PN}-ttfs-${PV}.7z
	)
"
RESTRICT="primaryuri"

LICENSE="OFL-1.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="l10n_ja l10n_ko l10n_zh-CN l10n_zh-TW"
REQUIRED_USE="
|| ( l10n_ja l10n_ko l10n_zh-CN l10n_zh-TW )
?? ( ${FONT_TYPES[@]/#+/} )
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
