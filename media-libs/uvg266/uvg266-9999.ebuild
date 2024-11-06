# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake-multilib

if [[ -z ${PV%%*9999} ]]; then
	EGIT_REPO_URI="https://github.com/ultravideo/${PN}.git"
	inherit git-r3
else
	MY_PV="d008a00"
	MY_GRT="greatest-60e25ce"
	[[ -n ${PV%%*_p*} ]] && MY_PV="v${PV}"
	SRC_URI="
		mirror://githubcl/ultravideo/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
		test? (
			mirror://githubcl/ultravideo/${MY_GRT%-*}/tar.gz/${MY_GRT##*-}
			-> ${MY_GRT}.tar.gz
		)
	"
	KEYWORDS="~amd64"
	S="${WORKDIR}/${PN}-${MY_PV#v}"
fi

DESCRIPTION="An open-source VVC encoder based on Kvazaar"
HOMEPAGE="https://github.com/ultravideo/${PN}"

LICENSE="BSD"
SLOT="0"

IUSE="test"
RESTRICT="!test? ( test )"
RESTRICT+=" primaryuri"

BDEPEND="
	test? ( media-video/ffmpeg )
"
PATCHES=( "${FILESDIR}"/tests.diff )

src_prepare() {
	sed -e '/(.*CMAKE_INSTALL_RPATH/d' -i CMakeLists.txt
	cmake_src_prepare
	use test || return
	if [[ -n ${PV%%*9999} ]]; then
		mv -T "${WORKDIR}"/${MY_GRT} greatest
	fi
}

multilib_src_configure() {
	local mycmakeargs=(
		-DBUILD_TESTS=$(usex test)
	)
	cmake_src_configure
}

src_test() {
	local -x BUILD_DIR="${BUILD_DIR}"
	cmake-multilib_src_test
}
