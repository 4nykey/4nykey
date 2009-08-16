# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/avidemux/avidemux-2.0.38_rc2-r1.ebuild,v 1.1 2005/04/18 15:44:32 flameeyes Exp $

inherit cmake-utils confutils subversion

DESCRIPTION="Great Video editing/encoding tool"
HOMEPAGE="http://fixounet.free.fr/avidemux/"
ESVN_REPO_URI="svn://svn.berlios.de/avidemux/branches/avidemux_2.6_branch_mean"
ESVN_PATCHES="${P}-*.diff"

LICENSE="GPL-2"
SLOT="3"
KEYWORDS="~amd64 ~x86"
IUSE="
	a52 alsa arts esd mmx nls vorbis sdl truetype xvid xv oss x264
	dts qt4 fontconfig lame aften gtk jack debug libsamplerate amrnb
	verbose-build faac faad vdpau opencore-amr bindist
"

RDEPEND="
	virtual/libiconv
	dev-libs/libxml2
	media-libs/libpng
	>=dev-lang/spidermonkey-1.5-r2
	gtk? ( >=x11-libs/gtk+-2.6.0 )
	qt4? ( x11-libs/qt-gui )
	x264? ( media-libs/x264 )
	xvid? ( media-libs/xvid )
	aften? ( media-libs/aften )
	amrnb? ( media-libs/amrnb )
	opencore-amr? ( media-libs/opencore-amr )
	lame? ( media-sound/lame )
	dts? ( media-libs/libdca )
	faad? ( media-libs/faad2 )
	faac? ( media-libs/faac )
	vorbis? ( media-libs/libvorbis )
	alsa? ( >=media-libs/alsa-lib-1.0.3b-r2 )
	arts? ( >=kde-base/arts-1.2.3 )
	esd? ( media-sound/esound )
	jack? (
		media-sound/jack-audio-connection-kit
		libsamplerate? ( media-libs/libsamplerate )
	)
	truetype? ( >=media-libs/freetype-2.1.5 )
	fontconfig? ( media-libs/fontconfig )
	sdl? ( media-libs/libsdl )
	xv? ( x11-libs/libXv )
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXrender
	vdpau? ( >=x11-drivers/nvidia-drivers-180.60 )
"
DEPEND="
	$RDEPEND
	oss? ( virtual/os-headers )
	dev-util/pkgconfig
	nls? ( sys-devel/gettext )
"

DOCS="AUTHORS"

pick() {
	local CMAKE_VAR="$(echo ${2:-${1}} | tr [a-z-] [A-Z_])"
	mycmakeargs+=" -D${CMAKE_VAR}=$(use $1 && echo ON || echo OFF)"
}

pkg_setup() {
	use verbose-build && CMAKE_COMPILER_VERBOSE=y
	CMAKE_IN_SOURCE_BUILD=y
	confutils_use_conflict amrnb bindist
}

src_compile() {
	# provide svn revision
	[[ -z ${ESVN_WC_REVISION} ]] && subversion_wc_info
	local x mycmakeargs="
		-DProject_WC_REVISION=${ESVN_WC_REVISION}
		-DAVIDEMUX_SOURCE_DIR=${S}
	"

	for x in ${IUSE}; do pick $x; done
	pick dts libdca
	pick truetype freetype2
	pick nls gettext
	pick xv xvideo
	pick opencore-amr opencore-amrwb
	pick opencore-amr opencore-amrnb

	# probably better is to split it to core/gtk/qt4 packages
	local dirlist="\"${S}/avidemux_core/ADM_smjs\" "
	dirlist+=$(find "${S}"/avidemux_core -type d -name src -printf "\"%p\" ")
	dirlist+=$(find "${S}"/avidemux_core/ADM_ffmpeg -mindepth 1 -maxdepth 1 \
		-type d -printf "\"%p\" ")
	sed -e "s:@ADM_CORE_DIRLIST@:${dirlist}:" \
		-i "${S}"/avidemux/{gtk,qt4}/CMakeLists.txt \
		"${S}"/avidemux_plugins/CMakeLists.txt

	CMAKE_USE_DIR="${S}"/avidemux_core \
		cmake-utils_src_compile
	use gtk && CMAKE_USE_DIR="${S}"/avidemux/gtk \
		cmake-utils_src_compile
	use qt4 && CMAKE_USE_DIR="${S}"/avidemux/qt4 \
		cmake-utils_src_compile
	CMAKE_USE_DIR="${S}"/avidemux_plugins \
		cmake-utils_src_compile
}
src_install() {
	CMAKE_USE_DIR="${S}"/avidemux_core \
		cmake-utils_src_install
	use gtk && CMAKE_USE_DIR="${S}"/avidemux/gtk \
		cmake-utils_src_install
	use qt4 && CMAKE_USE_DIR="${S}"/avidemux/qt4 \
		cmake-utils_src_install
	CMAKE_USE_DIR="${S}"/avidemux_plugins \
		cmake-utils_src_install
}
