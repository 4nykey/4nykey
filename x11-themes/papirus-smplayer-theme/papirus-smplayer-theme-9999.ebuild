# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit qmake-utils
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/PapirusDevelopmentTeam/${PN}.git"
else
	inherit vcs-snapshot
	MY_PV="760a52b"
	[[ -n ${PV%%*_p*} ]] && MY_PV="${PV//.}"
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

src_compile() {
	local d _rcc="$(usex qt5 $(qt5_get_bindir) $(qt4_get_bindir))/rcc -binary"
	for d in *Papirus*; do
		${_rcc} src/${d}.qrc -o ${d}.rcc || die
	done
}

src_install() {
	local d DOCS=( README.md )
	for d in *.rcc; do
		insinto /usr/share/smplayer/themes/${d%.*}
		doins ${d}
	done
	einstalldocs
}
