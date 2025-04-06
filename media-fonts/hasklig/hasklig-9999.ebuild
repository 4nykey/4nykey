# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{10..13} )
MY_FONT_TYPES=( otf +ttf )
MY_PN="${PN^}"
if [[ ${PV} == *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/i-tu/${MY_PN}"
	REQUIRED_USE="!binary"
else
	MY_PVB="${PV%_p*}"
	MY_PVB="${MY_PVB//_/-}"
	MY_PV="a94138e"
	[[ -n ${PV%%*_p*} ]] && MY_PV="v${PV//_/-}"
	SRC_URI="
		binary? (
			https://github.com/i-tu/${MY_PN}/releases/download/v${MY_PVB}/${MY_PN}-${MY_PVB}.zip
		)
		!binary? (
			mirror://githubcl/i-tu/${MY_PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
		)
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64"
	S="${WORKDIR}/${MY_PN}-${MY_PV#v}"
fi
inherit python-any-r1 font-r1

DESCRIPTION="A code font with monospaced ligatures"
HOMEPAGE="https://github.com/i-tu/${MY_PN}"

LICENSE="OFL-1.1"
SLOT="0"
IUSE="+binary -variable"

BDEPEND="
	!binary? (
		dev-util/afdko
		variable? ( dev-util/fontmake )
	)
"

pkg_setup() {
	use binary && S="${S%/*}"
	FONT_S=( $(usex binary . target)/$(usex variable VAR $(usex font_types_otf OTF TTF)) )
	font-r1_pkg_setup
}

src_compile() {
	use binary && return
	. ./build$(usex variable 'VFs' '').sh || die
}
