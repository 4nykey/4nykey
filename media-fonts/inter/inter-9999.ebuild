# Copyright 2019-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

FONT_SRCDIR=src
FONTDIR_BIN=( . )
FONTMAKE_EXTRA_ARGS=( '--fea-include-dir=src' )
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/rsms/${PN}.git"
	REQUIRED_USE="!binary"
else
	MY_PV="1cd1e1a"
	[[ -n ${PV%%*_p*} ]] && MY_PV="v$(ver_rs 2 -)"
	SRC_URI="
		binary? (
			https://github.com/rsms/${PN}/releases/download/${MY_PV}/Inter-${MY_PV#v}.zip
		)
		!binary? (
			mirror://githubcl/rsms/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
		)
	"
	KEYWORDS="~amd64"
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
	use binary && S="${S%/*}"
	fontmake_pkg_setup
}

src_prepare() {
	fontmake_src_prepare
	use binary || return
	use variable || FONT_SUFFIX=ttc
	use font_types_otf || rm -f Inter.ttc
	use font_types_ttf || rm -f 'Inter TrueType.ttc'
}
