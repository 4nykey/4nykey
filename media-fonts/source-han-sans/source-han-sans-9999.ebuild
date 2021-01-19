# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

MY_FONT_TYPES=( +otf ttc )
MY_PN="SourceHanSans"
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/adobe-fonts/${PN}"
else
	SRC_URI="mirror://githubraw/adobe-fonts/${PN}/${PV}R/SubsetOTF/${MY_PN}"
	SRC_URI="
		binary? (
		font_types_otf? (
			l10n_ja? ( ${SRC_URI}JP.zip -> ${MY_PN}JP-${PV}.zip )
			l10n_ko? ( ${SRC_URI}KR.zip -> ${MY_PN}KR-${PV}.zip )
			l10n_zh-CN? ( ${SRC_URI}CN.zip -> ${MY_PN}CN-${PV}.zip )
			l10n_zh-HK? ( ${SRC_URI}HK.zip -> ${MY_PN}HK-${PV}.zip )
			l10n_zh-TW? ( ${SRC_URI}TW.zip -> ${MY_PN}TW-${PV}.zip )
		)
		font_types_ttc? (
			https://github.com/adobe-fonts/${PN}/releases/download/${PV}R/${MY_PN}.ttc
			-> ${MY_PN}-${PV}.ttc
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
HOMEPAGE="https://github.com/adobe-fonts/source-han-sans/"

LICENSE="OFL-1.1"
SLOT="0"
IUSE_L10N=( ja ko zh-CN zh-HK zh-TW )
IUSE="+binary ${IUSE_L10N[@]/#/l10n_}"
REQUIRED_USE="
font_types_otf? ( || ( ${IUSE_L10N[@]/#/l10n_} ) )
?? ( ${MY_FONT_TYPES[@]/#+/} )
"

DEPEND="
	!binary? ( dev-util/afdko )
"

src_unpack() {
	if [[ ${PV} == *9999* ]]; then
		EGIT_BRANCH="$(usex binary release master)"
		git-r3_src_unpack
	elif use binary && use font_types_ttc; then
		cp "${DISTDIR}"/${A} "${WORKDIR}"
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
			$(usex l10n_zh-HK HK '')
			$(usex l10n_zh-TW TW '')
		)
		if [[ -n ${PV%%*9999} ]]; then
			S="${WORKDIR}"
			FONT_S=(
				${FONT_S[@]/#/${MY_PN}}
				.
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
