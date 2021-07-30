# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

SLOT="4"
MY_PN="${PN%-*}${SLOT}"
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/antlr/${MY_PN}.git"
else
	MY_PV="765de17"
	[[ -n ${PV%%*_p*} ]] && MY_PV="${PV}"
	SRC_URI="
		mirror://githubcl/antlr/${MY_PN}/tar.gz/${MY_PV}
		-> ${PN%-*}-${PV}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/${MY_PN}-${MY_PV}/runtime/Cpp"
fi
inherit cmake

DESCRIPTION="The ANTLR C++ Runtime"
HOMEPAGE="https://www.antlr.org/"

LICENSE="BSD"
SLOT="${SLOT}/$(ver_cut 1-3)"
DEPEND="
	dev-libs/utfcpp
	sys-apps/util-linux
"
RDEPEND="
	${DEPEND}
"

src_prepare() {
	rm -f ../../LICENSE.txt
	sed -e "/share\/doc/ s:libantlr4:${PF}:" -i CMakeLists.txt
	sed -e "/DESTINATION/s:\<lib\>:$(get_libdir):" -i runtime/CMakeLists.txt
	cmake_src_prepare
}
