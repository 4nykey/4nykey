# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit cmake-utils

DESCRIPTION="Pinky-Tagger is the mass tagger for Linux"
HOMEPAGE="http://pinkytagger.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="apidocs ffmpeg phonon verbose-build"

# it will use either lavc or lame for decoding
RDEPEND="
	x11-libs/qt-gui
	media-libs/jpeg
	media-libs/taglib
	media-libs/musicbrainz
	media-libs/libofa
	ffmpeg? ( media-video/ffmpeg )
	!ffmpeg? ( media-sound/lame )
	phonon? ( media-sound/phonon )
"
DEPEND="
	${RDEPEND}
	apidocs? ( app-doc/doxygen )
"
DOCS="AUTHORS NEWS README TODO"

pkg_setup() {
	use verbose-build && CMAKE_VERBOSE=y
}

src_prepare() {
	epatch "${FILESDIR}"/${PN}*.diff
}

src_configure() {
	local mycmakeargs="
		-DUSE_LIBFFMPEG=$(use !ffmpeg; echo $?)
		$(cmake-utils_use_has phonon PHONON)
		$(cmake-utils_use_build apidocs DOXYGEN)
	"
	cmake-utils_src_configure
}
