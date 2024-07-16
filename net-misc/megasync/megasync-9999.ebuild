# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="MEGAsync"
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/meganz/${MY_PN}.git"
	EGIT_SUBMODULES=( -src/MEGASync/mega )
else
	MY_PV="a795610"
	SRC_URI="
		mirror://githubcl/meganz/${MY_PN}/tar.gz/${MY_PV}
		-> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64"
	S="${WORKDIR}/${MY_PN}-${MY_PV}"
fi
inherit cmake xdg

DESCRIPTION="Easy automated syncing with MEGA Cloud Drive"
HOMEPAGE="https://github.com/meganz/MEGAsync"

LICENSE="EULA"
LICENSE_URL="https://raw.githubusercontent.com/meganz/MEGAsync/master/LICENCE.md"
SLOT="0"
IUSE="ffmpeg mediainfo raw"

RDEPEND="
	>=net-misc/meganz-sdk-7.1.2:=[ffmpeg?,libuv,mediainfo?,qt,raw?,sqlite]
	dev-qt/qtsvg:5
	dev-qt/qtx11extras:5
	dev-qt/qtdbus:5
	dev-qt/qtconcurrent:5
	dev-qt/qtimageformats:5
	dev-qt/qtnetwork:5
	dev-qt/qtdeclarative:5[widgets]
"
DEPEND="
	${RDEPEND}
	dev-util/breakpad
"
BDEPEND="
	dev-qt/linguist-tools:5
"
PATCHES=(
	"${FILESDIR}"/cmake.diff
)

src_prepare() {
	sed -e \
		"s:\${CMAKE_CURRENT_LIST_DIR}/src/MEGASync/mega/contrib/cmake/modules:${EPREFIX}/usr/share/mega/cmake:" \
		-i CMakeLists.txt
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DENABLE_DESKTOP_APP=yes
		-DENABLE_DESKTOP_UPDATE_GEN=no
		-DENABLE_DESKTOP_UPDATER=no
	)
	cmake_src_configure
}
