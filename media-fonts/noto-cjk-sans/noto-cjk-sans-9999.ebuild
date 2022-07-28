# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_FONT_TYPES=( +otf ttc )
MY_FONT_VARIANTS=( monospace )
MY_PN="${PN%-*}"
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/googlefonts/${MY_PN}"
	S="${WORKDIR}/${P}/Sans"
else
	WEIGHTS=( Black Bold DemiLight Light Medium Regular Thin )
	MY_PV="Sans${PV}"
	SRC_URI="mirror://githubraw/googlefonts/${MY_PN}/${MY_PV}/"
	SRC_URI="
	font_types_otf? (
		!variable? (
			l10n_ja? (
				$(for t in ${WEIGHTS[@]}; do
					printf "${SRC_URI}Sans/SubsetOTF/JP/NotoSansJP-%s.otf -> NotoSansJP-%s-${PV}.otf\n" ${t} ${t}
				done)
				font_variants_monospace? (
						${SRC_URI}Sans/Mono/NotoSansMonoCJKjp-Regular.otf -> NotoSansMonoCJKjp-Regular-${PV}.otf
						${SRC_URI}Sans/Mono/NotoSansMonoCJKjp-Bold.otf -> NotoSansMonoCJKjp-Bold-${PV}.otf
				)
			)
			l10n_ko? (
				$(for t in ${WEIGHTS[@]}; do
					printf "${SRC_URI}Sans/SubsetOTF/KR/NotoSansKR-%s.otf -> NotoSansKR-%s-${PV}.otf\n" ${t} ${t}
				done)
				font_variants_monospace? (
						${SRC_URI}Sans/Mono/NotoSansMonoCJKkr-Regular.otf -> NotoSansMonoCJKkr-Regular-${PV}.otf
						${SRC_URI}Sans/Mono/NotoSansMonoCJKkr-Bold.otf -> NotoSansMonoCJKkr-Bold-${PV}.otf
				)
			)
			l10n_zh-CN? (
				$(for t in ${WEIGHTS[@]}; do
					printf "${SRC_URI}Sans/SubsetOTF/SC/NotoSansSC-%s.otf -> NotoSansSC-%s-${PV}.otf\n" ${t} ${t}
				done)
				font_variants_monospace? (
						${SRC_URI}Sans/Mono/NotoSansMonoCJKsc-Regular.otf -> NotoSansMonoCJKsc-Regular-${PV}.otf
						${SRC_URI}Sans/Mono/NotoSansMonoCJKsc-Bold.otf -> NotoSansMonoCJKsc-Bold-${PV}.otf
				)
			)
			l10n_zh-HK? (
				$(for t in ${WEIGHTS[@]}; do
					printf "${SRC_URI}Sans/SubsetOTF/HK/NotoSansHK-%s.otf -> NotoSansHK-%s-${PV}.otf\n" ${t} ${t}
				done)
				font_variants_monospace? (
						${SRC_URI}Sans/Mono/NotoSansMonoCJKhk-Regular.otf -> NotoSansMonoCJKhk-Regular-${PV}.otf
						${SRC_URI}Sans/Mono/NotoSansMonoCJKhk-Bold.otf -> NotoSansMonoCJKhk-Bold-${PV}.otf
				)
			)
			l10n_zh-TW? (
				$(for t in ${WEIGHTS[@]}; do
					printf "${SRC_URI}Sans/SubsetOTF/TC/NotoSansTC-%s.otf -> NotoSansTC-%s-${PV}.otf\n" ${t} ${t}
				done)
				font_variants_monospace? (
						${SRC_URI}Sans/Mono/NotoSansMonoCJKtc-Regular.otf -> NotoSansMonoCJKtc-Regular-${PV}.otf
						${SRC_URI}Sans/Mono/NotoSansMonoCJKtc-Bold.otf -> NotoSansMonoCJKtc-Bold-${PV}.otf
				)
			)
		)
		variable? (
			l10n_ja? (
				${SRC_URI}Sans/Variable/OTF/Subset/NotoSansJP-VF.otf -> NotoSansJP-VF-${PV}.otf
				font_variants_monospace? (
					${SRC_URI}Sans/Variable/OTF/Mono/NotoSansMonoCJKjp-VF.otf -> NotoSansMonoCJKjp-VF-${PV}.otf
				)
			)
			l10n_ko? (
				${SRC_URI}Sans/Variable/OTF/Subset/NotoSansKR-VF.otf -> NotoSansKR-VF-${PV}.otf
				font_variants_monospace? (
					${SRC_URI}Sans/Variable/OTF/Mono/NotoSansMonoCJKkr-VF.otf -> NotoSansMonoCJKkr-VF-${PV}.otf
				)
			)
			l10n_zh-CN? (
				${SRC_URI}Sans/Variable/OTF/Subset/NotoSansSC-VF.otf -> NotoSansSC-VF-${PV}.otf
				font_variants_monospace? (
					${SRC_URI}Sans/Variable/OTF/Mono/NotoSansMonoCJKsc-VF.otf -> NotoSansMonoCJKsc-VF-${PV}.otf
				)
			)
			l10n_zh-HK? (
				${SRC_URI}Sans/Variable/OTF/Subset/NotoSansHK-VF.otf -> NotoSansHK-VF-${PV}.otf
				font_variants_monospace? (
					${SRC_URI}Sans/Variable/OTF/Mono/NotoSansMonoCJKhk-VF.otf -> NotoSansMonoCJKhk-VF-${PV}.otf
				)
			)
			l10n_zh-TW? (
				${SRC_URI}Sans/Variable/OTF/Subset/NotoSansTC-VF.otf -> NotoSansTC-VF-${PV}.otf
				font_variants_monospace? (
					${SRC_URI}Sans/Variable/OTF/Mono/NotoSansMonoCJKtc-VF.otf -> NotoSansMonoCJKtc-VF-${PV}.otf
				)
			)
		)
	)
	font_types_ttc? (
		!variable? (
			!super-otc? (
				$(for t in ${WEIGHTS[@]}; do
					printf "${SRC_URI}Sans/OTC/NotoSansCJK-%s.ttc -> NotoSansCJK-%s-${PV}.ttc\n" ${t} ${t}
				done)
			)
			super-otc? (
				${SRC_URI}Sans/SuperOTC/NotoSansCJK.ttc.zip -> NotoSansCJK-${PV}.ttc.zip
			)
		)
		variable? (
			${SRC_URI}Sans/Variable/OTC/NotoSansCJK-VF.otf.ttc -> NotoSansCJK-VF-${PV}.ttc
			font_variants_monospace? (
				${SRC_URI}Sans/Variable/OTC/NotoSansMonoCJK-VF.otf.ttc -> NotoSansMonoCJK-VF-${PV}.ttc
			)
		)
	)
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}"
fi
inherit font-r1

DESCRIPTION="Noto CJK sans-serif fonts"
HOMEPAGE="https://www.google.com/get/noto/help/cjk"

LICENSE="OFL-1.1"
SLOT="0"
IUSE_L10N=( ja ko zh-CN zh-HK zh-TW )
IUSE="${IUSE_L10N[@]/#/l10n_} super-otc variable"
REQUIRED_USE+="
?? ( ${MY_FONT_TYPES[@]/#+/} )
super-otc? (
	font_types_ttc
	!variable
)
font_types_otf? ( || ( ${IUSE_L10N[@]/#/l10n_} ) )
"
RDEPEND="
	!<media-fonts/noto-cjk-2.003
"
BDEPEND="
	super-otc? ( app-arch/unzip )
"

src_unpack() {
	local _f
	if [[ -z ${PV%%*9999} ]]; then
		git-r3_src_unpack
		cd "${S}"
		if use font_types_otf; then
			if use variable; then
				mv Variable/OTF/Subset/*.otf .
				use font_variants_monospace && mv Variable/OTF/Mono/*.otf .
			else
				mv SubsetOTF/*/*.otf .
				use font_variants_monospace && mv Mono/*.otf .
			fi
			use l10n_ja || rm -f NotoS*{jp,JP}-*.otf
			use l10n_ko || rm -f NotoS*{kr,KR}-*.otf
			use l10n_zh-CN || rm -f NotoS*{sc,SC}-*.otf
			use l10n_zh-HK || rm -f NotoS*{hk,HK}-*.otf
			use l10n_zh-TW || rm -f NotoS*{tc,TC}-*.otf
		elif use font_types_ttc; then
			if use variable; then
				mv Variable/OTC/NotoSansCJK-VF.otf.ttc .
				use font_variants_monospace && mv Variable/OTC/NotoSansMonoCJK-VF.otf.ttc .
			else
				if use super-otc; then
					unpack SuperOTC/NotoSansCJK.ttc.zip
				else
					mv OTC/NotoSansCJK-*.ttc .
				fi
			fi
		fi
	else
		for _f in ${A}; do
			case ${_f} in
				*.zip)
					unpack ${_f}
					;;
				*.ttc|*.otf)
					cp "${DISTDIR}"/${_f} ${_f/-${PV}}
					;;
			esac
		done
	fi
}
