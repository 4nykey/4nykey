# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

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
inherit font

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

FONT_SUFFIX="otf"
DOCS="README.md"

src_unpack() {
	if [[ ${PV} == *9999* ]]; then
		EGIT_BRANCH="$(usex binary release master)"
		git-r3_src_unpack
	else
		default
	fi
	mkdir -p "${S}"/SubsetOTF
}

src_prepare() {
	default
	if use binary; then
		if [[ -n ${PV%%*9999} ]]; then
			DOCS=
			mv "${WORKDIR}"/SourceHanSans* "${S}"/SubsetOTF/
		fi
		use l10n_ja || rm -r "${S}"/SubsetOTF/JP
		use l10n_ko || rm -r "${S}"/SubsetOTF/KR
		use l10n_zh-CN || rm -r "${S}"/SubsetOTF/CN
		use l10n_zh-TW || rm -r "${S}"/SubsetOTF/TW
	else
		eapply "${FILESDIR}"/${P}*.diff
	fi
}

src_compile() {
	if use binary; then
		find SubsetOTF -mindepth 2 -name '*.otf' -exec mv -f {} "${S}" \;
	else
		source "${EROOT}"etc/afdko
		source "${S}"/COMMANDS.txt
	fi
}
