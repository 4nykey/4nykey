# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_FONT_TYPES=( +otf ttc )
MY_PN="${PN%-*}"
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/googlefonts/${MY_PN}"
	S="${WORKDIR}/${P}/Serif"
else
	WEIGHTS=( Black Bold ExtraLight Light Medium Regular SemiBold )
	MY_PV="Serif${PV}"
	SRC_URI="mirror://githubraw/googlefonts/${MY_PN}/${MY_PV}/"
	SRC_URI="
	font_types_otf? (
		!variable? (
			l10n_ja? (
				$(for t in ${WEIGHTS[@]}; do
					printf "${SRC_URI}Serif/SubsetOTF/JP/NotoSerifJP-%s.otf -> NotoSerifJP-%s-${PV}.otf\n" ${t} ${t}
				done)
			)
			l10n_ko? (
				$(for t in ${WEIGHTS[@]}; do
					printf "${SRC_URI}Serif/SubsetOTF/KR/NotoSerifKR-%s.otf -> NotoSerifKR-%s-${PV}.otf\n" ${t} ${t}
				done)
			)
			l10n_zh-CN? (
				$(for t in ${WEIGHTS[@]}; do
					printf "${SRC_URI}Serif/SubsetOTF/SC/NotoSerifSC-%s.otf -> NotoSerifSC-%s-${PV}.otf\n" ${t} ${t}
				done)
			)
			l10n_zh-HK? (
				$(for t in ${WEIGHTS[@]}; do
					printf "${SRC_URI}Serif/SubsetOTF/HK/NotoSerifHK-%s.otf -> NotoSerifHK-%s-${PV}.otf\n" ${t} ${t}
				done)
			)
			l10n_zh-TW? (
				$(for t in ${WEIGHTS[@]}; do
					printf "${SRC_URI}Serif/SubsetOTF/TC/NotoSerifTC-%s.otf -> NotoSerifTC-%s-${PV}.otf\n" ${t} ${t}
				done)
			)
		)
		variable? (
			l10n_ja? (
				${SRC_URI}Serif/Variable/OTF/Subset/NotoSerifJP-VF.otf -> NotoSerifJP-VF-${PV}.otf
			)
			l10n_ko? (
				${SRC_URI}Serif/Variable/OTF/Subset/NotoSerifKR-VF.otf -> NotoSerifKR-VF-${PV}.otf
			)
			l10n_zh-CN? (
				${SRC_URI}Serif/Variable/OTF/Subset/NotoSerifSC-VF.otf -> NotoSerifSC-VF-${PV}.otf
			)
			l10n_zh-HK? (
				${SRC_URI}Serif/Variable/OTF/Subset/NotoSerifHK-VF.otf -> NotoSerifHK-VF-${PV}.otf
			)
			l10n_zh-TW? (
				${SRC_URI}Serif/Variable/OTF/Subset/NotoSerifTC-VF.otf -> NotoSerifTC-VF-${PV}.otf
			)
		)
	)
	font_types_ttc? (
		!variable? (
			$(for t in ${WEIGHTS[@]}; do
				printf "${SRC_URI}Serif/OTC/NotoSerifCJK-%s.ttc -> NotoSerifCJK-%s-${PV}.ttc\n" ${t} ${t}
			done)
		)
		variable? (
			${SRC_URI}Serif/Variable/OTC/NotoSerifCJK-VF.otf.ttc -> NotoSerifCJK-VF-${PV}.ttc
		)
	)
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}"
fi
inherit font-r1

DESCRIPTION="Noto CJK serif fonts"
HOMEPAGE="https://www.google.com/get/noto/help/cjk"

LICENSE="OFL-1.1"
SLOT="0"
IUSE_L10N=( ja ko zh-CN zh-HK zh-TW )
IUSE="${IUSE_L10N[@]/#/l10n_} variable"
REQUIRED_USE+="
?? ( ${MY_FONT_TYPES[@]/#+/} )
font_types_otf? ( || ( ${IUSE_L10N[@]/#/l10n_} ) )
"
RDEPEND="
	!<media-fonts/noto-cjk-2.003
"

src_unpack() {
	local _f
	if [[ -z ${PV%%*9999} ]]; then
		git-r3_src_unpack
		cd "${S}"
		if use font_types_otf; then
			if use variable; then
				mv Variable/OTF/Subset/*.otf .
			else
				mv SubsetOTF/*/*.otf .
			fi
			use l10n_ja || rm -f NotoS*{jp,JP}-*.otf
			use l10n_ko || rm -f NotoS*{kr,KR}-*.otf
			use l10n_zh-CN || rm -f NotoS*{sc,SC}-*.otf
			use l10n_zh-HK || rm -f NotoS*{hk,HK}-*.otf
			use l10n_zh-TW || rm -f NotoS*{tc,TC}-*.otf
		elif use font_types_ttc; then
			if use variable; then
				mv Variable/OTC/NotoSerifCJK-VF.otf.ttc .
			else
				mv OTC/NotoSerifCJK-*.ttc .
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
