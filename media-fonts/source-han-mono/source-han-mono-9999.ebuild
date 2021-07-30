# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

FONT_SUFFIX=ttc
MY_PN=SourceHanMono
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/adobe-fonts/${PN}.git"
	REQUIRED_USE="!binary"
else
	SRC_URI="mirror://githubraw/adobe-fonts/${PN}/${PV}R/SubsetOTF/${MY_PN}"
	SRC_URI="
		binary? (
			https://github.com/adobe-fonts/${PN}/releases/download/${PV}/${MY_PN}.ttc
			-> ${MY_PN}-${PV}.ttc
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

DESCRIPTION="A set of OpenType/CFF Pan-CJK monospace fonts"
HOMEPAGE="https://github.com/adobe-fonts/${PN}"

LICENSE="OFL-1.1"
SLOT="0"
IUSE="+binary"

DEPEND="
	!binary? ( dev-util/afdko )
"
PATCHES=( "${FILESDIR}"/cmds.diff )

pkg_setup() {
	if use binary; then
		S="${S%/*}"
		PATCHES=( )
	fi
	font-r1_pkg_setup
}

src_unpack() {
	if use binary; then
		cp "${DISTDIR}"/${MY_PN}-${PV}.ttc "${S}"/${MY_PN}.ttc
	else
		default
	fi
}

src_compile() {
	use binary && return
	source "${S}"/COMMANDS.txt
}
