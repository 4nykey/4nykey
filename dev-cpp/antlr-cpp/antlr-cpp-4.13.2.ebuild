# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="The ANTLR 4 C++ Runtime"
HOMEPAGE="https://www.antlr.org/"
SRC_URI="https://www.antlr.org/download/antlr4-cpp-runtime-${PV}-source.zip"
S="${WORKDIR}"

LICENSE="BSD"
SLOT="4/${PV}"
KEYWORDS="~amd64"
IUSE="test"
RESTRICT="!test? ( test )"

DEPEND="test? ( dev-cpp/gtest )"
BDEPEND="app-arch/unzip"

PATCHES=( "${FILESDIR}"/cmake.diff )

src_configure() {
	local mycmakeargs=(
		-DANTLR_BUILD_CPP_TESTS=$(usex test)
		-DWITH_STATIC_CRT=no
		-DANTLR_BUILD_SHARED=yes
		-DANTLR_BUILD_STATIC=no
	)
	cmake_src_configure
}
