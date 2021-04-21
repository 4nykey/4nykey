# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_FONT_TYPES=( +otf ttc )
MY_FONT_VARIANTS=( monospace +sans )
MY_PN="${PN%-*}"
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/googlefonts/${MY_PN}"
else
	WEIGHTS=( Black Bold DemiLight Light Medium Regular Thin )
	MY_PV="81a0432"
	SRC_URI="mirror://githubraw/googlefonts/${MY_PN}/${MY_PV}/"
	SRC_URI="
	font_types_otf? (
		!variable? (
			l10n_ja? (
				font_variants_sans? (
					$(for t in ${WEIGHTS[@]}; do
						printf "${SRC_URI}Sans/SubsetOTF/JP/NotoSansJP-%s.otf -> NotoSansJP-%s-${PV}.otf\n" ${t} ${t}
					done)
				)
				font_variants_monospace? (
						${SRC_URI}Sans/Mono/NotoSansMonoCJKjp-Regular.otf -> NotoSansMonoCJKjp-Regular-${PV}.otf
						${SRC_URI}Sans/Mono/NotoSansMonoCJKjp-Bold.otf -> NotoSansMonoCJKjp-Bold-${PV}.otf
				)
			)
			l10n_ko? (
				font_variants_sans? (
					$(for t in ${WEIGHTS[@]}; do
						printf "${SRC_URI}Sans/SubsetOTF/KR/NotoSansKR-%s.otf -> NotoSansKR-%s-${PV}.otf\n" ${t} ${t}
					done)
				)
				font_variants_monospace? (
						${SRC_URI}Sans/Mono/NotoSansMonoCJKkr-Regular.otf -> NotoSansMonoCJKkr-Regular-${PV}.otf
						${SRC_URI}Sans/Mono/NotoSansMonoCJKkr-Bold.otf -> NotoSansMonoCJKkr-Bold-${PV}.otf
				)
			)
			l10n_zh-CN? (
				font_variants_sans? (
					$(for t in ${WEIGHTS[@]}; do
						printf "${SRC_URI}Sans/SubsetOTF/SC/NotoSansSC-%s.otf -> NotoSansSC-%s-${PV}.otf\n" ${t} ${t}
					done)
				)
				font_variants_monospace? (
						${SRC_URI}Sans/Mono/NotoSansMonoCJKsc-Regular.otf -> NotoSansMonoCJKsc-Regular-${PV}.otf
						${SRC_URI}Sans/Mono/NotoSansMonoCJKsc-Bold.otf -> NotoSansMonoCJKsc-Bold-${PV}.otf
				)
			)
			l10n_zh-HK? (
				font_variants_sans? (
					$(for t in ${WEIGHTS[@]}; do
						printf "${SRC_URI}Sans/SubsetOTF/HK/NotoSansHK-%s.otf -> NotoSansHK-%s-${PV}.otf\n" ${t} ${t}
					done)
				)
				font_variants_monospace? (
						${SRC_URI}Sans/Mono/NotoSansMonoCJKhk-Regular.otf -> NotoSansMonoCJKhk-Regular-${PV}.otf
						${SRC_URI}Sans/Mono/NotoSansMonoCJKhk-Bold.otf -> NotoSansMonoCJKhk-Bold-${PV}.otf
				)
			)
			l10n_zh-TW? (
				font_variants_sans? (
					$(for t in ${WEIGHTS[@]}; do
						printf "${SRC_URI}Sans/SubsetOTF/TC/NotoSansTC-%s.otf -> NotoSansTC-%s-${PV}.otf\n" ${t} ${t}
					done)
				)
				font_variants_monospace? (
						${SRC_URI}Sans/Mono/NotoSansMonoCJKtc-Regular.otf -> NotoSansMonoCJKtc-Regular-${PV}.otf
						${SRC_URI}Sans/Mono/NotoSansMonoCJKtc-Bold.otf -> NotoSansMonoCJKtc-Bold-${PV}.otf
				)
			)
		)
		variable? (
			l10n_ja? (
				font_variants_sans? (
					${SRC_URI}Sans/Variable/Subset/NotoSansJP-VF.otf -> NotoSansJP-VF-${PV}.otf
				)
				font_variants_monospace? (
					${SRC_URI}Sans/Variable/Mono/NotoSansMonoCJKjp-VF.otf -> NotoSansMonoCJKjp-VF-${PV}.otf
				)
			)
			l10n_ko? (
				font_variants_sans? (
					${SRC_URI}Sans/Variable/Subset/NotoSansKR-VF.otf -> NotoSansKR-VF-${PV}.otf
				)
				font_variants_monospace? (
					${SRC_URI}Sans/Variable/Mono/NotoSansMonoCJKkr-VF.otf -> NotoSansMonoCJKkr-VF-${PV}.otf
				)
			)
			l10n_zh-CN? (
				font_variants_sans? (
					${SRC_URI}Sans/Variable/Subset/NotoSansSC-VF.otf -> NotoSansSC-VF-${PV}.otf
				)
				font_variants_monospace? (
					${SRC_URI}Sans/Variable/Mono/NotoSansMonoCJKsc-VF.otf -> NotoSansMonoCJKsc-VF-${PV}.otf
				)
			)
			l10n_zh-HK? (
				font_variants_sans? (
					${SRC_URI}Sans/Variable/Subset/NotoSansHK-VF.otf -> NotoSansHK-VF-${PV}.otf
				)
				font_variants_monospace? (
					${SRC_URI}Sans/Variable/Mono/NotoSansMonoCJKhk-VF.otf -> NotoSansMonoCJKhk-VF-${PV}.otf
				)
			)
			l10n_zh-TW? (
				font_variants_sans? (
					${SRC_URI}Sans/Variable/Subset/NotoSansTC-VF.otf -> NotoSansTC-VF-${PV}.otf
				)
				font_variants_monospace? (
					${SRC_URI}Sans/Variable/Mono/NotoSansMonoCJKtc-VF.otf -> NotoSansMonoCJKtc-VF-${PV}.otf
				)
			)
		)
	)
	font_types_ttc? (
		!variable? (
			!super-otc? (
				font_variants_sans? (
					$(for t in ${WEIGHTS[@]}; do
						printf "${SRC_URI}Sans/OTC/NotoSansCJK-%s.ttc -> NotoSansCJK-%s-${PV}.ttc\n" ${t} ${t}
					done)
				)
			)
			super-otc? (
				${SRC_URI}Sans/NotoSansCJK.ttc.zip -> NotoSansCJK-${PV}.ttc.zip
			)
		)
		variable? (
			font_variants_sans? (
				${SRC_URI}Sans/Variable/OTC/NotoSansCJK-VF.ttc -> NotoSansCJK-VF-${PV}.ttc
			)
			font_variants_monospace? (
				${SRC_URI}Sans/Variable/OTC/NotoSansMonoCJK.ttc -> NotoSansMonoCJK-${PV}.ttc
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
|| ( ${MY_FONT_VARIANTS[@]/#+/} )
super-otc? (
	font_types_ttc
	!variable
)
font_types_otf? ( || ( ${IUSE_L10N[@]/#/l10n_} ) )
font_types_ttc? (
	!variable? ( !super-otc? ( font_variants_sans ) )
)
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
			rm -f NotoS*CJK*.otf
			use l10n_ja || rm -f NotoS*JP-*.otf
			use l10n_ko || rm -f NotoS*KR-*.otf
			use l10n_zh-CN || rm -f NotoS*SC-*.otf
			use l10n_zh-TW || rm -f NotoS*TC-*.otf
			rm -f NotoSerif*.otf
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
