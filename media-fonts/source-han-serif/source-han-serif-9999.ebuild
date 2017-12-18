# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

MY_FONT_TYPES=( +otf ttc )
MY_PN="SourceHanSerif"
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/adobe-fonts/${PN}"
else
	MY_OTC=( ${MY_PN}OTC_{EL-M,SB-H}.zip )
	SRC_URI="mirror://githubraw/adobe-fonts/${PN}/release/SubsetOTF/${MY_PN}"
	SRC_URI="
		binary? (
		font_types_otf? (
			l10n_ja? ( ${SRC_URI}JP.zip -> ${MY_PN}JP-${PV}.zip )
			l10n_ko? ( ${SRC_URI}KR.zip -> ${MY_PN}KR-${PV}.zip )
			l10n_zh-CN? ( ${SRC_URI}CN.zip -> ${MY_PN}CN-${PV}.zip )
			l10n_zh-TW? ( ${SRC_URI}TW.zip -> ${MY_PN}TW-${PV}.zip )
		)
		font_types_ttc? (
			${MY_OTC[@]/#/mirror://githubraw/adobe-fonts/${PN}/release/OTC/}
		)
		)
		!binary? (
			mirror://githubcl/adobe-fonts/${PN}/tar.gz/${PV}
			-> ${P}.tar.gz
		)
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi
inherit font-r1

DESCRIPTION="A set of OpenType/CFF Pan-CJK fonts"
HOMEPAGE="https://source.typekit.com/${PN}"

LICENSE="OFL-1.1"
SLOT="0"
IUSE="+binary l10n_ja l10n_ko l10n_zh-CN l10n_zh-TW"
REQUIRED_USE="
|| ( l10n_ja l10n_ko l10n_zh-CN l10n_zh-TW )
?? ( ${MY_FONT_TYPES[@]/#+/} )
"

DEPEND="
	!binary? ( dev-util/afdko )
"

src_unpack() {
	if [[ ${PV} == *9999* ]]; then
		EGIT_BRANCH="$(usex binary release master)"
		git-r3_src_unpack
	else
		default
	fi
}

pkg_setup() {
	if use binary; then
		FONT_S=(
			$(usex l10n_ja JP '')
			$(usex l10n_ko KR '')
			$(usex l10n_zh-CN CN '')
			$(usex l10n_zh-TW TW '')
		)
		if [[ -n ${PV%%*9999} ]]; then
			S="${WORKDIR}"
			FONT_S=(
				${FONT_S[@]/#/${MY_PN}}
				${MY_OTC[@]/.zip}
			)
		else
			FONT_S=(
				${FONT_S[@]/#/SubsetOTF/}
				OTC
			)
			DOCS="*.pdf"
		fi
	else
		PATCHES=( "${FILESDIR}"/${PN}_cmds.diff )
	fi
	font-r1_pkg_setup
}

src_compile() {
	use binary && return
	source "${S}"/COMMANDS.txt
}
