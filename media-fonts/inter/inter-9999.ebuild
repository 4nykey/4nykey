# Copyright 2019-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

FONT_SRCDIR=src
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/rsms/${PN}.git"
	REQUIRED_USE="!binary"
else
	MY_PV="1cd1e1a"
	[[ -n ${PV%%*_p*} ]] && MY_PV="v${PV}"
	SRC_URI="
		binary? (
			https://github.com/rsms/${PN}/releases/download/v${PV%_p*}/${PN^}-${PV%_p*}.zip
		)
		!binary? (
			mirror://githubcl/rsms/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
		)
	"
	KEYWORDS="~amd64 ~x86"
	RESTRICT="primaryuri"
	S="${WORKDIR}/${PN}-${MY_PV#v}"
fi
inherit fontmake

DESCRIPTION="A typeface specially designed for user interfaces"
HOMEPAGE="https://rsms.me/inter"

LICENSE="OFL-1.1"
SLOT="0"
BDEPEND="
	binary? ( app-arch/unzip )
"
REQUIRED_USE+="
	binary? ( variable? ( !font_types_otf ) )
"

pkg_setup() {
	use binary && S="${WORKDIR}"
	use font_types_otf && FONTDIR_BIN=( 'Inter Desktop' )
	use font_types_ttf && FONTDIR_BIN=( 'Inter Hinted for Windows/Desktop' )
	use variable && FONTDIR_BIN=( 'Inter Variable' )
	fontmake_pkg_setup
}

src_prepare() {
	fontmake_src_prepare
	use binary && return
	local _d
	for _d in Inter{,Display}/master_ufo; do
		mkdir -p ${_d}
		ln -s {../../src,${_d}}/features
	done
}
