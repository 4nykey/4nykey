# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/PapirusDevelopmentTeam/${PN}.git"
else
	inherit vcs-snapshot
	MY_PV="f28e934"
	SRC_URI="
		mirror://githubcl/PapirusDevelopmentTeam/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi
DESCRIPTION="Papirus GTK theme for KDE"
HOMEPAGE="https://github.com/PapirusDevelopmentTeam/${PN}"

LICENSE="LGPL-2.1"
SLOT="0"
IUSE=""

DEPEND=""
RDEPEND="
	${DEPEND}
"
DOCS=( AUTHORS README.md )

src_prepare() {
	default
	rm -f "${S}"/Makefile
	find -mindepth 2 -type f -regex '.*\(AUTHORS\|LICENSE\)' -delete
	find -L -type l -delete
}

src_install() {
	default
	insinto /usr/share/themes
	doins -r papirus
}
