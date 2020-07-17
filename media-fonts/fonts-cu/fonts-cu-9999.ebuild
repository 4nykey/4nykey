# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_FONT_TYPES=( otf )
if [[ ${PV} == *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/typiconman/${PN}.git"
	REQUIRED_USE="!binary"
else
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
	S="${WORKDIR}/${PN}-${MY_PV#v}"
fi
RESTRICT="primaryuri"
inherit font-r1

DESCRIPTION="Unicode OpenType fonts for Church Slavonic"
HOMEPAGE="http://sci.ponomar.net/fonts.html"

LICENSE="|| ( GPL-3 OFL-1.1 )"
SLOT="0"
IUSE="+binary"

BDEPEND="
	binary? ( app-arch/unzip )
	!binary? ( media-gfx/fontforge[python] )
"

pkg_setup() {
	if use binary; then
		S="${WORKDIR}"
		DOCS="fonts-churchslavonic.pdf"
	fi
	font-r1_pkg_setup
}

src_compile() {
	use binary && return
	emake fonts
	find -type f -name '*.otf' -exec mv -t "${FONT_S}" {} +
}
