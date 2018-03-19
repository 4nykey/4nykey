# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit gnome2
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/PapirusDevelopmentTeam/${PN}.git"
	SRC_URI=
else
	inherit vcs-snapshot
	MY_PV="8f30100"
	[[ -n ${PV%%*_p*} ]] && MY_PV="${PV//.}"
	SRC_URI="
		mirror://githubcl/PapirusDevelopmentTeam/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi
DESCRIPTION="Papirus icon theme for GTK"
HOMEPAGE="https://github.com/PapirusDevelopmentTeam/${PN}"

LICENSE="CC-BY-SA-4.0"
SLOT="0"
IUSE=""

DEPEND=""
RDEPEND="
	${DEPEND}
	x11-themes/gtk-engines-murrine
	x11-libs/gdk-pixbuf:2
"
DOCS=( README.md )

src_prepare() {
	default
	find -mindepth 2 -type f -regex '.*\(AUTHORS\|LICENSE\)' -delete
	find -L -type l -delete
}

src_configure() { :; }
