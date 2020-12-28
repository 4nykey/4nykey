# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit qmake-utils
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/PapirusDevelopmentTeam/${PN}.git"
else
	MY_PV="adb28b8"
	[[ -n ${PV%%*_p*} ]] && MY_PV="${PV}"
	SRC_URI="
		mirror://githubcl/PapirusDevelopmentTeam/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/${PN}-${MY_PV}"
fi
DESCRIPTION="Papirus theme for SMPlayer"
HOMEPAGE="https://github.com/PapirusDevelopmentTeam/${PN}"

LICENSE="GPL-3"
SLOT="0"
IUSE=""

BDEPEND="
	dev-qt/qtcore:5
	gnome-base/librsvg
"
RDEPEND="
	media-video/smplayer
	!>=x11-themes/smplayer-themes-16.5.3
"

src_prepare() {
	default
	sed -e "s:/usr/lib/qt5/bin/rcc :$(qt5_get_bindir)/rcc :" -i build.sh
}

src_compile() {
	sh ./build.sh || die
	find -type f -name README.txt -delete
}

src_install() {
	insinto /usr/share/smplayer/themes
	doins -r ePapirus Papirus PapirusDark
	einstalldocs
}
