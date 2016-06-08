# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit qmake-utils
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/PapirusDevelopmentTeam/${PN}.git"
else
	inherit vcs-snapshot
	MY_PV="a7ce240"
	SRC_URI="
		mirror://githubcl/PapirusDevelopmentTeam/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi
DESCRIPTION="Papirus theme for SMPlayer"
HOMEPAGE="https://github.com/PapirusDevelopmentTeam/${PN}"

LICENSE="GPL-3"
SLOT="0"
IUSE="qt5"

DEPEND="
	!qt5? ( dev-qt/qtcore:4 )
	qt5? ( dev-qt/qtcore:5 )
"
RDEPEND="
	media-video/smplayer[qt5?]
	!>=x11-themes/smplayer-themes-16.5.3
"
DOCS=( AUTHORS README.md )

src_prepare() {
	default
	rm -f "${S}"/Makefile
	cd src
	mv dark Papirus
	mv white PapirusDark
	local d
	for d in Papirus{,Dark}; do
		printf \
			'<RCC><qresource prefix="/">%s</qresource></RCC>\n' \
			$(find ${d} -name '*.png' -printf '<file>%p</file>') \
			> ${d}.qrc
	done
}

src_compile() {
	local d _rcc="$(usex qt5 $(qt5_get_bindir) $(qt4_get_bindir))/rcc -binary"
	for d in Papirus{,Dark}; do
		${_rcc} src/${d}.qrc -o ${d}.rcc
	done
}

src_install() {
	default
	local d
	for d in Papirus{,Dark}; do
		insinto /usr/share/smplayer/themes/${d}
		doins ${d}.rcc
	done
}
