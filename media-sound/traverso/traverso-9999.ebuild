# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/traverso/traverso-0.41.0-r1.ebuild,v 1.2 2007/07/09 19:14:38 aballier Exp $

inherit cvs qt4 cmake-utils

DESCRIPTION="Professional Audio Tools for GNU/Linux"
HOMEPAGE="http://traverso-daw.org/"
ECVS_SERVER="cvs.savannah.nongnu.org:/sources/traverso"
ECVS_MODULE="${PN}"
S="${WORKDIR}/${ECVS_MODULE}"

IUSE="alsa jack lv2 opengl mad lame portaudio verbose-build pch debug"
SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86"

RDEPEND="
	$(qt4_min_version 4.2)
	>=dev-libs/glib-2.8
	>=media-libs/libsndfile-1.0.12
	media-libs/libsamplerate
	>=sci-libs/fftw-3
	alsa? ( media-libs/alsa-lib )
	jack? ( >=media-sound/jack-audio-connection-kit-0.100 )
	portaudio? ( >=media-libs/portaudio-19 )
	lv2? ( media-libs/slv2 )
	mad? ( media-libs/libmad )
	lame? ( media-sound/lame )
	media-sound/wavpack
	media-libs/libvorbis
	media-libs/flac
"
DEPEND="
	${RDEPEND}
	dev-util/pkgconfig
"

pkg_setup() {
	if use opengl && ! built_with_use =x11-libs/qt-4* opengl; then
		eerror "You need to build qt4 with opengl support to have it in ${PN}"
		die "Enabling opengl for traverso requires qt4 to be built with opengl support"
	fi
	use verbose-build && CMAKE_COMPILER_VERBOSE=y
}

src_unpack() {
	cvs_src_unpack
	cd "${S}"
	epatch "${FILESDIR}"/${PN}-*.diff
}

src_compile() {
	mycmakeargs="
		$(cmake-utils_use_want jack JACK) \
		$(cmake-utils_use_want alsa ALSA) \
		$(cmake-utils_use_want portaudio PORTAUDIO) \
		$(cmake-utils_use_want lv2 LV2) \
		-DUSE_SYSTEM_SLV2_LIBRARY=ON \
		$(cmake-utils_use_want mad MP3_DECODE) \
		$(cmake-utils_use_want lame MP3_ENCODE) \
		$(cmake-utils_use_want pch PCH) \
		$(cmake-utils_use_want debug DEBUG) \
		$(cmake-utils_use_want opengl OPENGL) \
	"
	cmake-utils_src_compile
}

src_install() {
	cmake-utils_src_install
	dodoc AUTHORS ChangeLog HISTORY README TODO resources/help.text
	cd resources
	find . -type d -name CVS | xargs rm -rf
	doicon freedesktop/icons/128x128/apps/traverso.png
	domenu traverso.desktop
	insinto /usr/share/mime/packages
	newins x-traverso.xml traverso.xml
	insinto /usr/share/icons/hicolor
	doins -r freedesktop/icons/*
	insinto /usr/share/${PN}
	doins -r themes
}
