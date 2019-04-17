# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

MY_FONT_TYPES=( ttc +otf )
MY_FONT_VARIANTS=( +sans serif )
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/googlefonts/${PN}"
else
	SANS_WEIGHTS=( Black Bold DemiLight Light Medium Regular Thin )
	SERIF_WEIGHTS=( Black Bold ExtraLight Light Medium Regular SemiBold )
	MY_PV="9beb8b8"
	[[ -n ${PV%%*_p*} ]] && MY_PV="NotoSansV${PV}"
	SRC_URI="mirror://githubraw/googlefonts/${PN}/${MY_PV}/Noto"
	SRC_URI="
	font_types_ttc? (
		font_variants_sans? (
			${SRC_URI}SansCJK.ttc.zip -> NotoSansCJK-${PV}.ttc.zip
		)
		font_variants_serif? (
			$(for t in ${SERIF_WEIGHTS[@]}; do
				printf "${SRC_URI}SerifCJK-%s.ttc
				-> NotoSerifCJK-%s-${PV}.ttc\n" ${t} ${t}
			done)
		)
	)
	font_types_otf? (
		l10n_ja? (
			font_variants_sans? (
				$(for t in ${SANS_WEIGHTS[@]}; do
					printf "${SRC_URI}SansJP-%s.otf
					-> NotoSansJP-%s-${PV}.otf\n" ${t} ${t}
				done)
			)
			font_variants_serif? (
				$(for t in ${SERIF_WEIGHTS[@]}; do
					printf "${SRC_URI}SerifJP-%s.otf
					-> NotoSerifJP-%s-${PV}.otf\n" ${t} ${t}
				done)
			)
		)
		l10n_ko? (
			font_variants_sans? (
				$(for t in ${SANS_WEIGHTS[@]}; do
					printf "${SRC_URI}SansKR-%s.otf
					-> NotoSansKR-%s-${PV}.otf\n" ${t} ${t}
				done)
			)
			font_variants_serif? (
				$(for t in ${SERIF_WEIGHTS[@]}; do
					printf "${SRC_URI}SerifKR-%s.otf
					-> NotoSerifKR-%s-${PV}.otf\n" ${t} ${t}
				done)
			)
		)
		l10n_zh-CN? (
			font_variants_sans? (
				$(for t in ${SANS_WEIGHTS[@]}; do
					printf "${SRC_URI}SansSC-%s.otf
					-> NotoSansSC-%s-${PV}.otf\n" ${t} ${t}
				done)
			)
			font_variants_serif? (
				$(for t in ${SERIF_WEIGHTS[@]}; do
					printf "${SRC_URI}SerifSC-%s.otf
					-> NotoSerifSC-%s-${PV}.otf\n" ${t} ${t}
				done)
			)
		)
		l10n_zh-TW? (
			font_variants_sans? (
				$(for t in ${SANS_WEIGHTS[@]}; do
					printf "${SRC_URI}SansTC-%s.otf
					-> NotoSansTC-%s-${PV}.otf\n" ${t} ${t}
				done)
			)
			font_variants_serif? (
				$(for t in ${SERIF_WEIGHTS[@]}; do
					printf "${SRC_URI}SerifTC-%s.otf
					-> NotoSerifTC-%s-${PV}.otf\n" ${t} ${t}
				done)
			)
		)
	)
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}"
fi
inherit font-r1

DESCRIPTION="Noto CJK fonts"
HOMEPAGE="https://www.google.com/get/noto/help/cjk"

LICENSE="OFL-1.1"
SLOT="0"
IUSE="l10n_ja l10n_ko l10n_zh-CN l10n_zh-TW"
REQUIRED_USE="
font_types_otf? ( || ( ${IUSE} ) )
?? ( ${MY_FONT_TYPES[@]/#+/} )
|| ( ${MY_FONT_VARIANTS[@]/#+/} )
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
			use font_variants_sans || rm -f NotoSans*.otf
			use font_variants_serif || rm -f NotoSerif*.otf
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
