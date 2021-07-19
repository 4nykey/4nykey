# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PN="cmake"
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/open-eid/${MY_PN}.git"
else
	MY_PV="40f4330"
	SRC_URI="
		mirror://githubcl/open-eid/${MY_PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/${MY_PN}-${MY_PV}"
fi

DESCRIPTION="Open-EID CMake modules"
HOMEPAGE="https://open-eid.github.io"

LICENSE="LGPL-2.1"
SLOT="0"
IUSE=""

RDEPEND=""
DEPEND=""

src_install() {
	insinto /usr/share/cmake/${PN#*-}
	doins modules/*.cmake
}
