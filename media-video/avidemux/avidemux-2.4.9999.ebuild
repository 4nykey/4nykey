# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/avidemux/avidemux-2.0.38_rc2-r1.ebuild,v 1.1 2005/04/18 15:44:32 flameeyes Exp $

EAPI="2"

inherit subversion cmake-utils

WANT_AUTOMAKE="1.9"
DESCRIPTION="Great Video editing/encoding tool"
HOMEPAGE="http://fixounet.free.fr/avidemux/"
ESVN_REPO_URI="svn://svn.berlios.de/avidemux/branches/avidemux_2.4_branch"
ESVN_PATCHES="${P}-*.diff"

LICENSE="GPL-2"
SLOT="2"
KEYWORDS="~x86 ~amd64"
IUSE="
	a52 faad alsa arts esd mmx nls png vorbis sdl truetype xvid xv oss x264
	dts qt4 fontconfig lame faac aften gtk jack debug libsamplerate amrnb
	verbose-build pulseaudio
"

RDEPEND="
	>=dev-libs/libxml2-2.6.7
	gtk? ( >=x11-libs/gtk+-2.6.0 )
	>=dev-lang/spidermonkey-1.5-r2
	a52? ( >=media-libs/a52dec-0.7.4 )
	aften? ( >=media-libs/aften-0.0.7 )
	faad? ( >=media-libs/faad2-2.0-r2 )
	faac? ( >=media-libs/faac-1.23.5 )
	mad? ( media-libs/libmad )
	lame? ( >=media-sound/lame-3.93 )
	xvid? ( >=media-libs/xvid-1.0.0 )
	nls? ( >=sys-devel/gettext-0.12.1 )
	vorbis? ( >=media-libs/libvorbis-1.0.1 )
	arts? ( >=kde-base/arts-1.2.3 )
	truetype? ( >=media-libs/freetype-2.1.5 )
	alsa? ( >=media-libs/alsa-lib-1.0.3b-r2 )
	x264? ( media-libs/x264 )
	png? ( media-libs/libpng )
	esd? ( media-sound/esound )
	dts? ( media-libs/libdca )
	sdl? ( media-libs/libsdl )
	xv? ( x11-libs/libXv )
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXrender
	qt4? ( x11-libs/qt-gui )
	fontconfig? ( media-libs/fontconfig )
	jack? ( media-sound/jack-audio-connection-kit )
	libsamplerate? ( media-libs/libsamplerate )
	amrnb? ( media-libs/amrnb )
	pulseaudio? ( media-sound/pulseaudio )
"
DEPEND="
	$RDEPEND
	oss? ( virtual/os-headers )
	x86? ( dev-lang/nasm )
	dev-util/pkgconfig
	nls? ( sys-devel/gettext )
"

DOCS="AUTHORS History"

pick() {
	use $1 || mycmakeargs+=" -DNO_${2:-${1}}=1"
}

pkg_setup() {
	use verbose-build && CMAKE_COMPILER_VERBOSE=y
}

src_configure() {
	# provide svn revision
	[[ -z ${ESVN_WC_REVISION} ]] && subversion_wc_info
	local mycmakeargs="
		-DNO_SVN=1
		-DSubversion_FOUND=1
		-DProject_WC_REVISION=${ESVN_WC_REVISION}
	"

	pick fontconfig FontConfig
	pick xv Xvideo
	pick esd Esd
	pick jack Jack
	pick aften Aften
	pick libsamplerate
	pick lame Lame
	pick xvid Xvid
	pick amrnb AMRNB
	pick dts libdca
	pick x264
	pick faad FAAD
	pick faac FAAC
	pick vorbis Vorbis
	pick fontconfig FontConfig
	pick truetype FREETYPE
	pick gtk GTK
	pick qt4 QT4
	pick arts ARTS
	pick pulseaudio PULSE_SIMPLE

	cmake-utils_src_configure
}
