# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/ericniebler/${PN}.git"
else
	inherit vcs-snapshot
	MY_PV="208413b"
	[[ -n ${PV%%*_p*} ]] && MY_PV="${PV}"
	SRC_URI="
		mirror://githubcl/ericniebler/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi
inherit cmake-utils

DESCRIPTION="Experimental range library for C++11/14/17"
HOMEPAGE="https://github.com/ericniebler/${PN}"

LICENSE="Boost-1.0"
SLOT="0"
IUSE="examples test"

RDEPEND=""
DEPEND="
	${RDEPEND}
"
DOCS=( {CREDITS,README,TODO}.md )

src_configure() {
	local mycmakeargs=(
		-DBUILD_TESTING=$(usex test)
		-DRANGE_V3_TESTS=$(usex test)
		-DRANGE_V3_EXAMPLES=$(usex examples)
		-DRANGE_V3_PERF=no
	)
	cmake-utils_src_configure
}
