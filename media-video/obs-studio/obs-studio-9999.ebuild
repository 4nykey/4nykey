# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/jp9000/${PN}.git"
	SRC_URI=
else
	inherit vcs-snapshot
	SRC_URI="
		mirror://githubcl/jp9000/${PN}/tar.gz/${PV} -> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi
inherit cmake-utils

DESCRIPTION="Open Broadcaster Software for live streaming and recording"
HOMEPAGE="https://obsproject.com"

LICENSE="GPL-2"
SLOT="0"
IUSE="ffmpeg imagemagick qt5 alsa jack pulseaudio v4l udev fdk openssl x264 truetype vlc"

DEPEND="
	ffmpeg? ( virtual/ffmpeg )
	!ffmpeg? ( media-gfx/imagemagick )
	qt5? (
		dev-qt/qtwidgets:5
		dev-qt/qtx11extras:5
		net-misc/curl
	)
	dev-libs/jansson
	virtual/opengl
	x11-libs/libXcomposite
	x11-libs/libXinerama
	alsa? ( media-libs/alsa-lib )
	jack? ( virtual/jack )
	pulseaudio? ( media-sound/pulseaudio )
	v4l? (
		media-libs/libv4l
		udev? ( virtual/libudev )
	)
	fdk? ( media-libs/fdk-aac )
	openssl? ( dev-libs/openssl:0 )
	x264? ( media-libs/x264 )
	truetype? ( media-libs/fontconfig )
	vlc? ( media-video/vlc )
"
RDEPEND="${DEPEND}"
DOCS=( README CONTRIBUTING )

src_configure() {
	local mycmakeargs
	mycmakeargs=(
		-DUSE_XDG=yes
		-DLIBOBS_PREFER_IMAGEMAGICK=$(usex imagemagick)
		-DENABLE_UI=$(usex qt5)
	)
	# plugins
	mycmakeargs+=(
		-DDISABLE_ALSA=$(usex !alsa)
		-DDISABLE_JACK=$(usex !jack)
		-DDISABLE_PULSEAUDIO=$(usex !pulseaudio)
		-DDISABLE_V4L2=$(usex !v4l)
		-DDISABLE_UDEV=$(usex !udev)
		-DDISABLE_LIBFDK=$(usex !fdk)
		-DUSE_SSL=$(usex openssl)
		-DDISABLE_FREETYPE=$(usex !truetype)
		-DDISABLE_VLC=$(usex !vlc)
	)
	cmake-utils_src_configure
}
