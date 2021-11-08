# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_FONT_TYPES=( +otf ttc )
MY_PN="SourceHanSerif"
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/adobe-fonts/${PN}"
else
	SRC_URI="mirror://githubraw/adobe-fonts/${PN}/${PV}R/"
	SRC_URIB="https://github.com/adobe-fonts/${PN}/releases/download/${PV}R/${MY_PN}"
	SRC_URI="
	binary? (
		font_types_otf? (
			!variable? (
				l10n_ja? (
					${SRC_URIB}JP.zip -> ${MY_PN}JP-${PV}.zip
				)
				l10n_ko? (
					${SRC_URIB}KR.zip -> ${MY_PN}KR-${PV}.zip
				)
				l10n_zh-CN? (
					${SRC_URIB}CN.zip -> ${MY_PN}CN-${PV}.zip
				)
				l10n_zh-HK? (
					${SRC_URIB}HK.zip -> ${MY_PN}HK-${PV}.zip
				)
				l10n_zh-TW? (
					${SRC_URIB}TC.zip -> ${MY_PN}TC-${PV}.zip
				)
			)
			variable? (
				l10n_ja? (
					${SRC_URI}Variable/OTF/Subset/${MY_PN}JP-VF.otf -> ${MY_PN}JP-VF-${PV}.otf
				)
				l10n_ko? (
					${SRC_URI}Variable/OTF/Subset/${MY_PN}KR-VF.otf -> ${MY_PN}KR-VF-${PV}.otf
				)
				l10n_zh-CN? (
					${SRC_URI}Variable/OTF/Subset/${MY_PN}CN-VF.otf -> ${MY_PN}CN-VF-${PV}.otf
				)
				l10n_zh-HK? (
					${SRC_URI}Variable/OTF/Subset/${MY_PN}HK-VF.otf -> ${MY_PN}HK-VF-${PV}.otf
				)
				l10n_zh-TW? (
					${SRC_URI}Variable/OTF/Subset/${MY_PN}TW-VF.otf -> ${MY_PN}TW-VF-${PV}.otf
				)
			)
		)
		font_types_ttc? (
			variable? (
				${SRC_URI}Variable/OTC/${MY_PN}-VF.otf.ttc -> ${MY_PN}-VF-${PV}.ttc
			)
			!variable? (
				super-otc? (
					${SRC_URIB}.ttc.zip -> ${MY_PN}-${PV}.ttc.zip
				)
				!super-otc? (
					${SRC_URIB}OTC.zip
				)
			)
		)
	)
	!binary? (
		mirror://githubcl/adobe-fonts/${PN}/tar.gz/${PV} -> ${P}.tar.gz
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
IUSE_L10N=( ja ko zh-CN zh-HK zh-TW )
IUSE="+binary ${IUSE_L10N[@]/#/l10n_} super-otc variable"
REQUIRED_USE+="
?? ( ${MY_FONT_TYPES[@]/#+/} )
super-otc? (
	font_types_ttc
	!variable
)
font_types_otf? (
	|| ( ${IUSE_L10N[@]/#/l10n_} )
)
variable? ( binary )
"
BDEPEND="
	!binary? ( dev-util/afdko )
	!variable? ( app-arch/unzip )
"
PATCHES=( "${FILESDIR}"/${PN}_cmds.diff )

pkg_setup() {
	if use binary; then
		S="${S%/*}"
		PATCHES=( )
	fi
	font-r1_pkg_setup
}

src_unpack() {
	if [[ ${PV} == *9999* ]]; then
		EGIT_BRANCH="$(usex binary release master)"
		git-r3_src_unpack
	elif use binary && use variable; then
		cp -ut "${S}" $(printf "${DISTDIR}/%s " ${A})
	else
		default
	fi
}

src_compile() {
	use binary && return
	mv Masters/* .
	source "${S}"/COMMANDS.txt
}

src_install() {
	find -mindepth 2 -type f -name "*.${FONT_SUFFIX#* }" -exec mv -t "${S}" {} +
	font-r1_src_install
}
