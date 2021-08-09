# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PN="swift-corelibs-${PN}"
if [[ ${PV} = *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/apple/${MY_PN}.git"
else
	[[ -n ${PV%%*_p*} ]] && MY_PV="swift-${PV}-RELEASE"
	SRC_URI="
		mirror://githubcl/apple/${MY_PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/${MY_PN}-${MY_PV}"
fi
inherit cmake

DESCRIPTION="A library for concurrent code execution on multicore hardware"
HOMEPAGE="https://swift.org"

LICENSE="Apache-2.0"
SLOT="0"

IUSE=""

RDEPEND="
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	sys-devel/clang
"

pkg_setup() {
	tc-is-clang && return
	CC=${CHOST}-clang
	CXX=${CHOST}-clang++
	strip-unsupported-flags
}

src_configure () {
	local mycmakeargs=(
		-DINSTALL_BLOCK_HEADERS_DIR="${EPREFIX}/usr/include/dispatch"
	)
	cmake_src_configure
}
