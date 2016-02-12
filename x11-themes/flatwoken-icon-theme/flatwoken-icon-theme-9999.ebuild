# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit gnome2
if [[ -z ${PV%%*9999} ]]; then
	SRC_URI=""
	EGIT_REPO_URI="https://github.com/alecive/FlatWoken.git"
	inherit git-r3
else
	inherit vcs-snapshot
	MY_PV="37a797e"
	SRC_URI="
		mirror://githubcl/alecive/FlatWoken/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="FlatWoken icon theme"
HOMEPAGE="https://github.com/alecive/FlatWoken"

LICENSE="CC-BY-SA-4.0"
SLOT="0"
IUSE=""

DEPEND=""
RDEPEND="
	${DEPEND}
"

src_configure() { :; }
src_compile() { :; }

src_install() {
	find -L -type l -delete
	insinto /usr/share/icons
	doins -r FlatWoken*
	dodoc README*
}
