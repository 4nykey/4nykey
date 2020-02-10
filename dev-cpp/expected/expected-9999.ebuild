# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/TartanLlama/${PN}.git"
else
	MY_PV="v${PV}"
	if [[ -z ${PV%%*_p*} ]]; then
		inherit vcs-snapshot
		MY_PV="3d74170"
	fi
	MY_CM="tl-cmake-284c6a3"
	SRC_URI="
		mirror://githubcl/TartanLlama/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
		mirror://githubcl/TartanLlama/${MY_CM%-*}/tar.gz/${MY_CM##*-} -> ${MY_CM}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi
inherit cmake

DESCRIPTION="C++11/14/17 std::expected with functional-style extensions"
HOMEPAGE="https://tl.tartanllama.xyz"

LICENSE="CC0-1.0"
SLOT="0"
IUSE="test"

RDEPEND=""
DEPEND="
	${RDEPEND}
"

src_prepare() {
	local PATCHES=(
		"${FILESDIR}"/${PN}-cmake.diff
	)
	if [[ -n ${PV%%*9999} ]]; then
		mv "${WORKDIR}"/${MY_CM}/* "${S}"/cmake/${MY_CM%-*}
	fi
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DEXPECTED_ENABLE_TESTS=$(usex test)
	)
	cmake_src_configure
}
