# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

MY_FONT_TYPES=( ttc +otf )
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/googlei18n/${PN}"
else
	SANS_WEIGHTS=( Black Bold DemiLight Light Medium Regular Thin )
	SERIF_WEIGHTS=( Black Bold ExtraLight Light Medium Regular SemiBold )
	MY_PV="9beb8b8"
	[[ -n ${PV%%*_p*} ]] && MY_PV="v${PV}"
	SRC_URI="mirror://githubraw/googlei18n/${PN}/${MY_PV}/Noto"
	SRC_URI="
	font_types_ttc? ( $(
	for t in ${SANS_WEIGHTS[@]}; do
		printf "${SRC_URI}SansCJK-%s.ttc -> NotoSansCJK-%s_${MY_PV}.ttc\n" ${t} ${t}
	done
	for t in ${SERIF_WEIGHTS[@]}; do
		printf "${SRC_URI}SerifCJK-%s.ttc -> NotoSerifCJK-%s_${MY_PV}.ttc\n" ${t} ${t}
	done
	) )
	font_types_otf? (
	l10n_ja? ( $(
	for t in ${SANS_WEIGHTS[@]}; do
		printf "${SRC_URI}SansJP-%s.otf -> NotoSansJP-%s_${MY_PV}.otf\n" ${t} ${t}
	done
	for t in ${SERIF_WEIGHTS[@]}; do
		printf "${SRC_URI}SerifJP-%s.otf -> NotoSerifJP-%s_${MY_PV}.otf\n" ${t} ${t}
	done
	) )
	l10n_ko? ( $(
	for t in ${SANS_WEIGHTS[@]}; do
		printf "${SRC_URI}SansKR-%s.otf -> NotoSansKR-%s_${MY_PV}.otf\n" ${t} ${t}
	done
	for t in ${SERIF_WEIGHTS[@]}; do
		printf "${SRC_URI}SerifKR-%s.otf -> NotoSerifKR-%s_${MY_PV}.otf\n" ${t} ${t}
	done
	) )
	l10n_zh-CN? ( $(
	for t in ${SANS_WEIGHTS[@]}; do
		printf "${SRC_URI}SansSC-%s.otf -> NotoSansSC-%s_${MY_PV}.otf\n" ${t} ${t}
	done
	for t in ${SERIF_WEIGHTS[@]}; do
		printf "${SRC_URI}SerifSC-%s.otf -> NotoSerifSC-%s_${MY_PV}.otf\n" ${t} ${t}
	done
	) )
	l10n_zh-TW? ( $(
	for t in ${SANS_WEIGHTS[@]}; do
		printf "${SRC_URI}SansTC-%s.otf -> NotoSansTC-%s_${MY_PV}.otf\n" ${t} ${t}
	done
	for t in ${SERIF_WEIGHTS[@]}; do
		printf "${SRC_URI}SerifTC-%s.otf -> NotoSerifTC-%s_${MY_PV}.otf\n" ${t} ${t}
	done
	) )
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
|| ( ${IUSE} )
?? ( ${MY_FONT_TYPES[@]/#+/} )
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
		fi
	else
		for _f in ${A}; do cp "${DISTDIR}"/${_f} ${_f/_*./.}; done
	fi
}
