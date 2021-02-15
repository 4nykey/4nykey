# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

FONTDIR_BIN=( static/ttf )
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/googlefonts/${PN}.git"
else
	MY_PV="${PV}"
	[[ -z ${PV%%*_p*} ]] && MY_PV="0cc48b5"
	SRC_URI="
	binary? (
		https://github.com/googlefonts/literata/releases/download/${PV}/${PN^}-v${PV%_p*}.zip
	)
	!binary? (
		mirror://githubcl/googlefonts/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	)
	"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/${PN}-${MY_PV}"
fi
inherit fontmake

DESCRIPTION="A contemporary serif typeface family for long-form reading"
HOMEPAGE="https://github.com/googlefonts/${PN}"

LICENSE="OFL-1.1"
SLOT="0"
REQUIRED_USE="
	binary? ( !font_types_otf )
"

pkg_setup() {
	if use binary; then
		FONTDIR_BIN=( $(usex variable variable static/ttf) )
		if [[ -z ${PV%%*9999} ]]; then
			EGIT_BRANCH=release
			FONTDIR_BIN=( ${FONTDIR_BIN[*]/#/fonts/} )
		else
			S="${WORKDIR}"
		fi
	fi
	fontmake_pkg_setup
}

src_prepare() {
	fontmake_src_prepare
	use binary && return
	cd sources
	rm -f _Literata-Italic.designspace
	local _v
	if use variable; then
		for _v in vf-*.designspace; do mv ${_v} ${PN^}-${_v#vf-}; done
		rm -f static-*.designspace
	else
		rm -f vf-*.designspace
	fi
}
