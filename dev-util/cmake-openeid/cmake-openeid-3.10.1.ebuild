# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit unpacker
MY_PN="cmake"
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/open-eid/${MY_PN}.git"
else
	MY_PV="${PV/_/-}"
	MY_PV="${MY_PV/rc/RC}"
	SRC_URI="
		https://codeload.github.com/open-eid/${MY_PN}/tar.gz/v${MY_PV}
		-> ${P}.tar.gz
	"
	S="${WORKDIR}/${MY_PN}-${MY_PV}"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="Open-EID CMake modules"
HOMEPAGE="http://id.ee"

LICENSE="LGPL-2.1"
SLOT="0"
IUSE=""

RDEPEND=""
DEPEND="
	${RDEPEND}
	$(unpacker_src_uri_depends)
"
RDEPEND="
	${RDEPEND}
	app-misc/esteidcerts
"

DOCS="README*"

src_install() {
	insinto /usr/share/cmake/${PN#*-}
	doins modules/*.cmake
}
