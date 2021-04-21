# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_FONT_TYPES=( +otf ttc )
MY_PN="${PN%-*}"
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/googlefonts/${MY_PN}"
else
	WEIGHTS=( Black Bold ExtraLight Light Medium Regular SemiBold )
	MY_PV="81a0432"
	SRC_URI="mirror://githubraw/googlefonts/${MY_PN}/${MY_PV}/"
	SRC_URI="
	font_types_otf? (
		l10n_ja? (
			$(for t in ${WEIGHTS[@]}; do
				printf "${SRC_URI}Serif/NotoSerifJP-%s.otf -> NotoSerifJP-%s-${PV}.otf\n" ${t} ${t}
			done)
		)
		l10n_ko? (
			$(for t in ${WEIGHTS[@]}; do
				printf "${SRC_URI}Serif/NotoSerifKR-%s.otf -> NotoSerifKR-%s-${PV}.otf\n" ${t} ${t}
			done)
		)
		l10n_zh-CN? (
			$(for t in ${WEIGHTS[@]}; do
				printf "${SRC_URI}Serif/NotoSerifSC-%s.otf -> NotoSerifSC-%s-${PV}.otf\n" ${t} ${t}
			done)
		)
		l10n_zh-TW? (
			$(for t in ${WEIGHTS[@]}; do
				printf "${SRC_URI}Serif/NotoSerifTC-%s.otf -> NotoSerifTC-%s-${PV}.otf\n" ${t} ${t}
			done)
		)
	)
	font_types_ttc? (
		$(for t in ${WEIGHTS[@]}; do
			printf "${SRC_URI}Serif/NotoSerifCJK-%s.ttc -> NotoSerifCJK-%s-${PV}.ttc\n" ${t} ${t}
		done)
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
IUSE_L10N=( ja ko zh-CN zh-TW )
IUSE="${IUSE_L10N[@]/#/l10n_}"
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
			rm -f NotoS*CJK*.otf
			use l10n_ja || rm -f NotoS*JP-*.otf
			use l10n_ko || rm -f NotoS*KR-*.otf
			use l10n_zh-CN || rm -f NotoS*SC-*.otf
			use l10n_zh-TW || rm -f NotoS*TC-*.otf
			rm -f NotoSans*.otf
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
