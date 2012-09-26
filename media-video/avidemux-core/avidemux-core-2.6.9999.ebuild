# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

inherit cmake-utils git-2

DESCRIPTION="Avidemux core libraries"
HOMEPAGE="http://fixounet.free.fr/avidemux/"
EGIT_REPO_URI="git://gitorious.org/avidemux2-6/avidemux2-6.git"

LICENSE="GPL-2"
SLOT="3"
KEYWORDS="~amd64 ~x86"
IUSE="
	nls sdl sqlite3 vdpau xv
"

RDEPEND="
	virtual/libiconv
	dev-libs/libxml2
	media-libs/libpng
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXrender
	sdl? ( media-libs/libsdl )
	xv? ( x11-libs/libXv )
	vdpau? ( x11-libs/libvdpau )
	sqlite3? ( dev-db/sqlite:3 )
"
DEPEND="
	$RDEPEND
	dev-util/pkgconfig
	nls? ( sys-devel/gettext )
"

DOCS="AUTHORS"
CMAKE_USE_DIR="${S}"/avidemux_core

src_prepare() {
	sed -i cmake/ffmpeg_make.sh.cmake \
		-e 's:^"\${ffmpeg_gnumake_executable.*:emake:'
}

src_configure() { 
	local x mycmakeargs
	mycmakeargs="
		-DAVIDEMUX_SOURCE_DIR=${S}
		$(for x in ${IUSE}; do cmake-utils_use $x; done)
		$(cmake-utils_use xv XVIDEO)
	"
	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile -j1
}

src_install() {
	cmake-utils_src_install -j1
}
