# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/PapirusDevelopmentTeam/${PN}.git"
else
	inherit vcs-snapshot
	MY_PV="8778dc2"
	[[ -n ${PV%%*_p*} ]] && MY_PV="${PV//.}"
	SRC_URI="
		mirror://githubcl/PapirusDevelopmentTeam/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi
DESCRIPTION="Arc KDE customization"
HOMEPAGE="https://github.com/PapirusDevelopmentTeam/${PN}"

LICENSE="GPL-3 CC-BY-SA-4.0"
SLOT="0"
IUSE="konsole kvantum"

DEPEND=""
RDEPEND="
	${DEPEND}
	konsole? ( kde-apps/konsole )
	kvantum? ( x11-themes/kvantum )
"
DOCS=( AUTHORS README.md )

src_prepare() {
	default
	rm -f "${S}"/Makefile
	find -mindepth 2 -name AUTHORS | xargs cat >> AUTHORS
	find -mindepth 2 -regex '.*\(LICENSE\|AUTHORS\)' -delete
}

src_install() {
	default
	insinto /usr/share/color-schemes
	doins color-schemes/Arc*.colors
	insinto /usr/share/
	doins -r plasma wallpapers $(usex kvantum Kvantum '')
	insinto /usr/share/konsole
	use konsole && doins konsole/Arc*.colorscheme
}
