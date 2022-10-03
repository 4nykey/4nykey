# Copyright 2019-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/rsms/${PN}.git"
	REQUIRED_USE="!binary"
else
	MY_PV="1cd1e1a"
	[[ -n ${PV%%*_p*} ]] && MY_PV="v$(ver_rs 2 -)"
	SRC_URI="
		binary? (
			https://github.com/rsms/${PN}/releases/download/${MY_PV}/Inter-4.00-3f174fcef6.zip
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
	!binary? ( dev-python/glyphspkg )
"
REQUIRED_USE+="
	binary? ( variable? ( !font_types_otf ) )
"

pkg_setup() {
	use binary && S="${S%/*}"
	use font_types_otf && FONTDIR_BIN=( 'Desktop' )
	use font_types_ttf && FONTDIR_BIN=( 'Desktop with TrueType hints' )
	use variable && FONTDIR_BIN=( 'Variable' )
	fontmake_pkg_setup
}

src_prepare() {
	fontmake_src_prepare
	use binary && return
	mkdir sources
	glyphspkg -o sources src/Inter-Roman.glyphspackage || die
	glyphspkg -o sources src/Inter-Italic.glyphspackage || die
	local _d
	for _d in Inter-{Italic,Roman}/master_ufo; do
		mkdir -p ${_d}
		ln -s {../../src,${_d}}/features
	done
}
