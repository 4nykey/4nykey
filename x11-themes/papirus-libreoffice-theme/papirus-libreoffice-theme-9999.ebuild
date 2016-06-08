# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/PapirusDevelopmentTeam/${PN}.git"
else
	inherit vcs-snapshot
	MY_PV="b2b9e7b"
	SRC_URI="
		mirror://githubcl/PapirusDevelopmentTeam/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi
DESCRIPTION="Papirus theme for Libreoffice"
HOMEPAGE="https://github.com/PapirusDevelopmentTeam/${PN}"

LICENSE="GPL-3"
SLOT="0"
IUSE=""

DEPEND=""
RDEPEND="
	${DEPEND}
	|| ( app-office/libreoffice app-office/libreoffice-bin )
"
DOCS=( AUTHORS README.md )

src_prepare() {
	default
	rm -f "${S}"/Makefile
}

src_install() {
	default
	insinto /usr/$(get_libdir)/libreoffice/share/config
	doins images_papirus*.zip
}
