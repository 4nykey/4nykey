# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

FONT_TYPES="otf"
if [[ ${PV} == *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/adobe-fonts/${PN}"
else
	MY_PN="SourceHanSans"
	SRC_URI="https://github.com/adobe-fonts/${PN}/raw/${PV}R/SubsetOTF/${MY_PN}"
	SRC_URI="
		binary? (
			l10n_ja? ( ${SRC_URI}JP.zip -> ${MY_PN}JP-${PV}.zip )
			l10n_ko? ( ${SRC_URI}KR.zip -> ${MY_PN}KR-${PV}.zip )
			l10n_zh-CN? ( ${SRC_URI}CN.zip -> ${MY_PN}CN-${PV}.zip )
			l10n_zh-TW? ( ${SRC_URI}TW.zip -> ${MY_PN}TW-${PV}.zip )
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

DESCRIPTION="Pan-CJK OpenType/CFF font family"
HOMEPAGE="https://github.com/adobe-fonts/source-han-sans/"

LICENSE="OFL-1.1"
SLOT="0"
IUSE="+binary l10n_ja l10n_ko l10n_zh-CN l10n_zh-TW monospace"
REQUIRED_USE="|| ( l10n_ja l10n_ko l10n_zh-CN l10n_zh-TW )"

DEPEND="
	!binary? ( dev-util/afdko )
"
RDEPEND="
	l10n_ja? ( monospace? ( media-fonts/source-han-code-jp ) )
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
			FONT_S=( ${FONT_S[@]/#/SourceHanSans} )
		else
			S="${WORKDIR}/${P}/SubsetOTF"
		fi
	else
		PATCHES=( "${FILESDIR}"/${P}-cmds.diff )
		source "${EROOT}"etc/afdko
	fi
}

src_compile() {
	use binary && return
	source "${S}"/COMMANDS.txt
}
