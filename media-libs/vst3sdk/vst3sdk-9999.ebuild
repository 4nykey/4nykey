# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CMAKE_BUILD_TYPE="Release"
inherit cmake
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/steinbergmedia/${PN}.git"
else
	MY_PV="$(ver_rs 3 '_build-' 4 '_' 5-6 '-')"
	SRC_URI="
		https://download.steinberg.net/sdk_downloads/vst-sdk_${MY_PV}.zip
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/VST_SDK/${PN}"
fi

DESCRIPTION="VST 3 Plug-In SDK"
HOMEPAGE="https://steinbergmedia.github.io/vst3_doc"

LICENSE="GPL-3"
SLOT="0"
IUSE="X debug jack static"
DEPEND="
	X? (
		dev-db/sqlite
		dev-libs/expat
		media-libs/fontconfig
		x11-libs/pango[X]
		x11-libs/libxkbcommon[X]
		x11-libs/libxcb[xkb]
		x11-libs/xcb-util
		x11-libs/xcb-util-cursor
		dev-cpp/gtkmm:3.0
	)
	jack? ( virtual/jack )
"
RDEPEND="
	${DEPEND}
"

src_prepare() {
	sed -e '/add_subdirectory(public.sdk\/samples/d' -i CMakeLists.txt

	printf 'configure_file(${CMAKE_CURRENT_SOURCE_DIR}/vst3sdk.pc.in
	    ${CMAKE_CURRENT_BINARY_DIR}/vst3sdk.pc @ONLY)
	install(FILES ${CMAKE_CURRENT_BINARY_DIR}/vst3sdk.pc
	    DESTINATION ${CMAKE_INSTALL_LIBDIR}/pkgconfig)
	install(DIRECTORY "${CMAKE_SOURCE_DIR}/" DESTINATION "include/vst3sdk"
	    FILES_MATCHING PATTERN "*.h")
	install(DIRECTORY "${vstsdk_BINARY_DIR}/lib/${CMAKE_BUILD_TYPE}/"
	    DESTINATION "${CMAKE_INSTALL_LIBDIR}/vst3sdk")\n' >> CMakeLists.txt

	cp "${FILESDIR}"/${PN}.pc.in .

	cmake_src_prepare

	use static && return
	sed -e '/add_library(/ s:\<STATIC\>::' \
		-i {base,pluginterfaces}/CMakeLists.txt \
		vstgui4/vstgui/{lib,standalone,uidescription}/CMakeLists.txt \
		cmake/modules/SMTG_VstGuiSupport.cmake
	sed -e '/^\s*\<STATIC\>\s*$/d' -i public.sdk/CMakeLists.txt
}

src_configure() {
	use debug && CMAKE_BUILD_TYPE="Debug"
	local mycmakeargs=(
		-DCMAKE_BUILD_RPATH_USE_ORIGIN=yes
		-DSMTG_ADD_VST3_PLUGINS_SAMPLES=no
		-DSMTG_ADD_VSTGUI=$(usex X)
		-DSMTG_RUN_VST_VALIDATOR=no
		-DSMTG_CREATE_MODULE_INFO=no
	)
	cmake_src_configure
}
