# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DOCS_BUILDER="doxygen"
DOCS_DIR="doc"
inherit cmake-multilib docs
MY_PN="${PN%-*}"
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/dyne/${MY_PN}.git"
else
	MY_PV="9d3a813"
	[[ -n ${PV%%*_p*} ]] && MY_PV="v${PV}"
	SRC_URI="
		mirror://githubcl/dyne/${MY_PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64"
	S="${WORKDIR}/${MY_PN}-${MY_PV#v}"
fi

DESCRIPTION="A minimalistic plugin API for video effects"
HOMEPAGE="https://www.dyne.org/software/frei0r/"

LICENSE="GPL-2"
SLOT="0"
IUSE="doc +facedetect +scale0tilt"

RDEPEND="
	x11-libs/cairo[${MULTILIB_USEDEP}]
	facedetect? ( >=media-libs/opencv-2.3.0:=[contrib,contribdnn,features2d,ffmpeg,${MULTILIB_USEDEP}] )
	scale0tilt? ( >=media-libs/gavl-1.2.0[${MULTILIB_USEDEP}] )
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	virtual/pkgconfig
	doc? ( app-text/doxygen[dot] )
"

src_prepare() {
	cmake_src_prepare

	# https://bugs.gentoo.org/418243
	sed -i \
		-e '/set.*CMAKE_C_FLAGS/s:"): ${CMAKE_C_FLAGS}&:' \
		src/filter/*/CMakeLists.txt || die
}

src_configure() {
	local mycmakeargs=(
		-DWITHOUT_OPENCV=$(usex !facedetect)
		-DWITHOUT_GAVL=$(usex !scale0tilt)
	)
	cmake-multilib_src_configure
}

src_compile() {
	cmake-multilib_src_compile
	use doc && docs_compile
}
