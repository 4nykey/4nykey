# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit bash-completion-r1 toolchain-funcs xdg cmake desktop

if [[ -z ${PV%%*9999} ]]; then
	EGIT_REPO_URI="https://github.com/GreycLab/${PN}.git"
	inherit git-r3
else
	MY_PV="15d552d"
	[[ -n ${PV%%*_p*} ]] && MY_PV="v.${PV}"
	MY_CI="CImg-${MY_PV}"
	MY_ST="gmic_stdlib_community$(ver_rs 1-2 '').h"
	SRC_URI="
		https://gmic.eu/files/source/${PN}_${PV}.tar.gz
		https://gmic.eu/${MY_ST}
		mirror://githubcl/GreycLab/${MY_CI%-*}/tar.gz/${MY_CI#*-}
		-> ${MY_CI}.tar.gz
	"
	KEYWORDS="~amd64"
	RESTRICT="primaryuri"
fi

DESCRIPTION="GREYC's Magic Image Converter"
HOMEPAGE="https://gmic.eu https://github.com/GreycLab/gmic"

LICENSE="|| ( CeCILL-C CeCILL-2 )"
SLOT="0"
IUSE="
bash-completion curl ffmpeg fftw gimp graphicsmagick gui jpeg
opencv openexr openmp png qt6 static-libs tiff X
"
REQUIRED_USE="
	gimp? ( qt6 )
	gui? ( qt6 )
"

DEPEND="
	fftw? ( sci-libs/fftw:3.0[threads] )
	gimp? ( media-gfx/gimp )
	qt6? ( dev-qt/qtbase:=[gui,network,widgets] )
	graphicsmagick? ( media-gfx/graphicsmagick )
	jpeg? ( virtual/jpeg:0 )
	opencv? ( media-libs/opencv:= )
	openexr? (
		media-libs/openexr:=
	)
	png? ( media-libs/libpng:0= )
	tiff? ( media-libs/tiff:= )
	X? (
		x11-libs/libX11
		x11-libs/libXext
		x11-libs/libxcb
	)
	curl? ( net-misc/curl )
	virtual/zlib
"
RDEPEND="
	${DEPEND}
	ffmpeg? ( media-video/ffmpeg:0 )
"
BDEPEND="
	virtual/pkgconfig
	qt6? ( dev-qt/qttools:6[linguist] )
"
PATCHES=(
	"${FILESDIR}"/gmic-qt.diff
)

pkg_setup() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

src_prepare() {
	cp "${DISTDIR}"/${MY_ST} ../gmic_stdlib_community.h
	mv --target-directory=src --update=none \
		../${MY_CI}/CImg.h ../gmic_stdlib_community.h
	sed -e '/STRIP_TOOL/ s:\<strip\>:no_&:' -i CMakeLists.txt
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_LIB_STATIC=$(usex static-libs)
		-DCUSTOM_CFLAGS=yes
		-DENABLE_DYNAMIC_LINKING=$(usex !static-libs)
	)
	cmake_src_configure

	local -x Gmic_DIR="${BUILD_DIR}" CMAKE_USE_DIR="${S}/gmic-qt"
	mycmakeargs=(
		-DGMIC_LIB_PATH=${Gmic_DIR}
		-DBUILD_WITH_QT6=yes
		-DENABLE_SYSTEM_GMIC=yes
		-DENABLE_DYNAMIC_LINKING=$(usex !static-libs)
		-DENABLE_CURL=$(usex curl)
		-DENABLE_FFTW3=$(usex fftw)
	)
	if use gimp; then
		local _g
		has_version media-gfx/gimp:0/3 && _g=3
		mycmakeargs+=(
			-DGMIC_QT_HOST=gimp${_g}
		)
		BUILD_DIR="${WORKDIR}/gimp_build" \
		cmake_src_configure
	fi
	if use gui; then
		mycmakeargs+=(
			-DGMIC_QT_HOST=none
		)
		BUILD_DIR="${WORKDIR}/gui_build" \
		cmake_src_configure
	fi
}

src_compile() {
	cmake_src_compile
	local -x Gmic_DIR="${BUILD_DIR}" CMAKE_USE_DIR="${S}/gmic-qt"
	if use gimp; then
		BUILD_DIR="${WORKDIR}/gimp_build" \
		cmake_src_compile
	fi
	if use gui; then
		BUILD_DIR="${WORKDIR}/gui_build" \
		cmake_src_compile
	fi
}

src_install() {
	cmake_src_install
	local CMAKE_USE_DIR="${S}/gmic-qt"
	if use gimp; then
		BUILD_DIR="${WORKDIR}/gimp_build" \
		cmake_src_install
	fi
	if use gui; then
		BUILD_DIR="${WORKDIR}/gui_build" \
		cmake_src_install
		domenu gmic-qt/gmic_qt.desktop
	fi
	insinto /usr/share/gmic
	doins resources/*.gmz
}
