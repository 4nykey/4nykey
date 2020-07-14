# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8} )
MY_FONT_TYPES=( otf )
if [[ ${PV} == *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/typiconman/${PN}.git"
	REQUIRED_USE="!binary"
else
	inherit vcs-snapshot
	MY_PV="5f897fd"
	[[ -n ${PV%%*_p*} ]] && MY_PV="v${PV}"
	SRC_URI="
	binary? (
		https://github.com/typiconman/${PN}/releases/download/v${PV%_p*}/fonts-churchslavonic.zip
		-> ${P}.zip
	)
	!binary? (
		mirror://githubcl/typiconman/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	)
	"
	KEYWORDS="~amd64 ~x86"
fi
RESTRICT="primaryuri"
inherit python-single-r1 font-r1

DESCRIPTION="Unicode OpenType fonts for Church Slavonic"
HOMEPAGE="http://sci.ponomar.net/fonts.html"

LICENSE="|| ( GPL-3 OFL-1.1 )"
SLOT="0"
IUSE="+binary"

BDEPEND="
	binary? ( app-arch/unzip )
	!binary? (
		${PYTHON_DEPS}
		$(python_gen_cond_dep '
			media-gfx/fontforge[python,${PYTHON_SINGLE_USEDEP}]
		')
	)
"

pkg_setup() {
	if use binary; then
		S="${WORKDIR}"
		DOCS="fonts-churchslavonic.pdf"
	else
		python-single-r1_pkg_setup
		PATCHES=( "${FILESDIR}"/${PN}_generate.diff )
	fi
	font-r1_pkg_setup
}

src_compile() {
	use binary && return
	local _s
	for _s in */*.sfd; do
		fontforge -script hp-generate.py ${_s} || die
	done

}
