# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit xdg
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/PapirusDevelopmentTeam/${PN}.git"
	SRC_URI=
else
	SRC_URI="
		mirror://githubcl/PapirusDevelopmentTeam/${PN}/tar.gz/${PV}
		-> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi
DESCRIPTION="Papirus icon theme for GTK"
HOMEPAGE="https://git.io/papirus-icon-theme"

LICENSE="GPL-3"
SLOT="0"
IUSE="test"

DEPEND=""
RDEPEND="
	${DEPEND}
"
BDEPEND="
	test? ( app-text/xmlstarlet )
"

src_test() {
	emake test-all
}
