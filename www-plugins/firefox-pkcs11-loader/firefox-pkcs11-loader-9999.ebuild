# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/open-eid/${PN}.git"
else
	inherit vcs-snapshot
	MY_PV="610427e"
	[[ -n ${PV%%*_p*} ]] && MY_PV="v${PV}"
	SRC_URI="
		mirror://githubcl/open-eid/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi
inherit cmake-utils

DESCRIPTION="A Firefox extension for automatical loading of OpenSC PKCS11 module"
HOMEPAGE="https://open-eid.github.io"

LICENSE="LGPL-2.1"
SLOT="0"
IUSE=""

RDEPEND="
"
DEPEND="
	${RDEPEND}
	app-arch/zip
"

src_compile() {
	cmake-utils_src_compile extension
}
