# Copyright 2024-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake xdg

if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/${PN}/${PN}.git"
else
	MY_PV="f77a890"
	[[ -n ${PV%%*_p*} ]] && MY_PV="v${PV}"
	SRC_URI="
		mirror://githubcl/${PN}/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64"
	S="${WORKDIR}/${PN}-${MY_PV#v}"
fi

DESCRIPTION="A customizable music player"
HOMEPAGE="https://www.fooyin.org"

LICENSE="GPL-3"
SLOT="0"
IUSE="alsa archive gme loudness openmpt pipewire nls pch sanitize sdl sndfile soundtouch soxr test"
REQUIRED_USE="
	|| ( alsa pipewire sdl )
"

RDEPEND="
	dev-libs/icu:=
	dev-libs/kdsingleapplication
	dev-libs/qcoro[network]
	dev-qt/qtbase:6[concurrent,dbus,gui,network,sql,widgets]
	dev-qt/qtimageformats:6
	dev-qt/qtsvg:6
	media-libs/taglib:=
	media-video/ffmpeg:=
	alsa? ( media-libs/alsa-lib )
	archive? ( app-arch/libarchive:= )
	gme? ( media-libs/game-music-emu )
	loudness? ( media-libs/libebur128:= )
	openmpt? ( media-libs/libopenmpt )
	pipewire? ( media-video/pipewire:= )
	sdl? ( media-libs/libsdl2 )
	sndfile? ( media-libs/libsndfile )
	soundtouch? ( media-libs/libsoundtouch:= )
	soxr? ( media-libs/soxr )
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-qt/qttools:6[linguist]
	test? ( dev-cpp/gtest )
"

src_prepare() {
	sed -e "/DOC_INSTALL_DIR/ s:\<fooyin\>:${PF}:" -i CMakeLists.txt
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_SHARED_LIBS=yes
		-DBUILD_TESTING=$(usex test)
		-DBUILD_SENSITIVE_TESTING=$(usex test)
		-DBUILD_PLUGINS=yes
		-DBUILD_ALSA=$(usex alsa)
		-DBUILD_TRANSLATIONS=$(usex nls)
		-DBUILD_CCACHE=no
		-DBUILD_PCH=$(usex pch)
		-DBUILD_WERROR=no
		-DBUILD_ASAN=$(usex sanitize)
		-DINSTALL_FHS=ON
		-DINSTALL_HEADERS=ON
		$(cmake_use_find_package archive LibArchive)
		$(cmake_use_find_package gme LIBGME)
		$(cmake_use_find_package openmpt OpenMpt)
		$(cmake_use_find_package pipewire PipeWire)
		$(cmake_use_find_package loudness Ebur128)
		$(cmake_use_find_package sdl SDL2)
		$(cmake_use_find_package sndfile SndFile)
		$(cmake_use_find_package soundtouch SoundTouch)
		$(cmake_use_find_package soxr SoXR)
	)
	cmake_src_configure
}

src_test() {
	BUILD_DIR="${BUILD_DIR}/tests" cmake_src_test
}
