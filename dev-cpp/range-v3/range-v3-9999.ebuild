# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/ericniebler/${PN}.git"
else
	MY_PV="${PV}"
	if [[ -z ${PV%%*_p*} ]]; then
		inherit vcs-snapshot
		MY_PV="208413b"
	fi
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
IUSE="apidocs examples test"

RDEPEND=""
DEPEND="
	${RDEPEND}
"
DOCS=( {CREDITS,README,TODO}.md )

src_configure() {
	local mycmakeargs=(
		-DRANGE_V3_DOCS=$(usex apidocs)
		-DCMAKE_DISABLE_FIND_PACKAGE_Doxygen=$(usex !apidocs)
		-DCMAKE_DISABLE_FIND_PACKAGE_Git=yes
		-DRANGE_V3_TESTS=$(usex test)
		-DRANGE_V3_HEADER_CHECKS=$(usex test)
		-DRANGE_V3_EXAMPLES=$(usex examples)
		-DRANGE_V3_PERF=no
	)
	cmake-utils_src_configure
}
