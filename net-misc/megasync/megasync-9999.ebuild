# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="MEGAsync"
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/meganz/${MY_PN}.git"
	EGIT_SUBMODULES=( -src/MEGASync/mega )
else
	MY_PV="8178c16"
	SRC_URI="
		mirror://githubcl/meganz/${MY_PN}/tar.gz/${MY_PV}
		-> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64"
	S="${WORKDIR}/${MY_PN}-${MY_PV}"
fi
VIRTUALX_REQUIRED="test"
inherit virtualx cmake xdg

DESCRIPTION="Easy automated syncing with MEGA Cloud Drive"
HOMEPAGE="https://github.com/meganz/MEGAsync"

LICENSE="EULA"
LICENSE_URL="https://raw.githubusercontent.com/meganz/MEGAsync/master/LICENCE.md"
SLOT="0"
IUSE="breakpad dolphin ffmpeg mediainfo nautilus raw test"

RDEPEND="
	>=net-misc/meganz-sdk-9.10:=[ffmpeg?,libuv,mediainfo?,qt,raw?,sqlite]
	dev-qt/qtsvg:5
	dev-qt/qtx11extras:5
	dev-qt/qtdbus:5
	dev-qt/qtconcurrent:5
	dev-qt/qtimageformats:5
	dev-qt/qtnetwork:5
	dev-qt/qtdeclarative:5[widgets]
	nautilus? ( gnome-base/nautilus )
	breakpad? ( dev-util/breakpad )
	dolphin? ( kde-apps/dolphin )
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	dev-qt/linguist-tools:5
"
PATCHES=(
	"${FILESDIR}"/cmake.diff
)

src_prepare() {
	sed -e \
		"s:\${CMAKE_CURRENT_LIST_DIR}/src/MEGASync/mega/cmake/modules:${EPREFIX}/usr/share/mega/cmake:" \
		-i CMakeLists.txt
	sed \
		-e "/MEGAShellExtDolphin/s:.*\(add_subdirectory\):$(usex dolphin '' '#')\1:" \
		-e "/MEGAShellExtNautilus/s:.*\(add_subdirectory\):$(usex nautilus '' '#')\1:" \
		-i src/CMakeLists.txt
	sed -e '/KF_VER/ s:"5":"6":' -i src/MEGAShellExtDolphin/CMakeLists.txt
	ln -s ../../MEGASync/gui src/MEGAAutoTests/UnitTests/gui
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DENABLE_DESKTOP_APP=yes
		-DENABLE_DESKTOP_UPDATE_GEN=no
		-DENABLE_DESKTOP_UPDATER=no
		-DENABLE_DESKTOP_APP_TESTS=$(usex test)
		-DENABLE_LINUX_EXT=yes
		-DUSE_BREAKPAD=$(usex breakpad)
	)
	cmake_src_configure
}

src_test() {
	virtx "${BUILD_DIR}"/src/MEGAAutoTests/UnitTests/UnitTests || die "UnitTests failed"
}
