# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/audacious-media-player/${PN}.git"
else
	SRC_URI="
		https://distfiles.audacious-media-player.org/${P}.tar.bz2
	"
	if [[ -z ${PV%%*_p*} ]]; then
		MY_PV="b29776e"
		SRC_URI="
			mirror://githubcl/audacious-media-player/${PN}/tar.gz/${MY_PV}
			-> ${P}.tar.gz
		"
		S="${WORKDIR}/${PN}-${MY_PV}"
	fi
	RESTRICT="primaryuri"
	KEYWORDS="~amd64"
fi

DESCRIPTION="Plugins for Audacious music player"
HOMEPAGE="https://audacious-media-player.org/"

LICENSE="GPL-2"
SLOT="0"
IUSE="
	aac +alsa ampache bs2b cdda cue ffmpeg flac fluidsynth gme http jack
	lame libnotify libsamplerate lirc mms modplug mp3 nls opengl openmpt
	opus pipewire pulseaudio scrobbler sdl sid sndfile soxr speedpitch
	streamtuner vorbis wavpack
"
IUSE+=" gtk"

REQUIRED_USE="ampache? ( http ) streamtuner? ( http )"

# The following plugins REQUIRE a GUI build of audacious, because non-GUI
# builds do NOT install the libaudgui library & headers.
# Plugins without a configure option:
#   albumart
#   delete-files
#   ladspa
#   playlist-manager
#   search-tool
#   skins
#   vtx
# Plugins with a configure option:
#   gtkui
#   hotkey
#   notify
#   statusicon
BDEPEND="
	dev-util/gdbus-codegen
	virtual/pkgconfig
	nls? ( dev-util/intltool )
"
DEPEND="
	app-arch/unzip
	dev-libs/glib:2
	dev-libs/libxml2:2
	dev-qt/qtbase:6[gui,opengl,network,widgets]
	dev-qt/qtmultimedia:6
	dev-qt/qtwidgets:5
	~media-sound/audacious-${PV}
	sys-libs/zlib
	x11-libs/gdk-pixbuf:2
	aac? ( >=media-libs/faad2-2.7 )
	alsa? ( >=media-libs/alsa-lib-1.0.16 )
	ampache? ( =media-libs/ampache_browser-1*:= )
	bs2b? ( media-libs/libbs2b )
	cdda? (
		dev-libs/libcdio:=
		dev-libs/libcdio-paranoia:=
		>=media-libs/libcddb-1.2.1
	)
	cue? ( media-libs/libcue:= )
	ffmpeg? ( >=media-video/ffmpeg-0.7.3:= )
	flac? (
		>=media-libs/flac-1.2.1-r1:=
		>=media-libs/libvorbis-1.0
	)
	fluidsynth? ( media-sound/fluidsynth:= )
	gtk? ( x11-libs/gtk+:3 )
	http? ( >=net-libs/neon-0.26.4 )
	jack? (
		>=media-libs/bio2jack-0.4
		virtual/jack
	)
	lame? ( media-sound/lame )
	libnotify? ( x11-libs/libnotify )
	libsamplerate? ( media-libs/libsamplerate:= )
	lirc? ( app-misc/lirc )
	mms? ( >=media-libs/libmms-0.3 )
	modplug? ( media-libs/libmodplug )
	mp3? ( >=media-sound/mpg123-1.12.1 )
	opengl? ( dev-qt/qtopengl:5 )
	openmpt? ( media-libs/libopenmpt )
	opus? ( media-libs/opusfile )
	pipewire? ( media-video/pipewire:= )
	pulseaudio? ( media-libs/libpulse )
	scrobbler? ( net-misc/curl )
	sdl? ( media-libs/libsdl2[sound] )
	sid? ( >=media-libs/libsidplayfp-1.0.0 )
	sndfile? ( >=media-libs/libsndfile-1.0.17-r1 )
	soxr? ( media-libs/soxr )
	speedpitch? ( media-libs/libsamplerate:= )
	streamtuner? ( dev-qt/qtnetwork:5 )
	vorbis? (
		>=media-libs/libogg-1.1.3
		>=media-libs/libvorbis-1.2.0
	)
	wavpack? ( >=media-sound/wavpack-4.50.1-r1 )
"
RDEPEND="${DEPEND}"

pkg_setup() {
	use mp3 || ewarn "MP3 support is optional, you may want to enable the mp3 USE-flag"
}

src_prepare() {
	default
	if ! use nls; then
		sed -e "/subdir('po')/d" -i meson.build || die "failed to sed" # bug #512698
	fi
}

src_configure() {
	local emesonargs=(
		$(meson_use gtk)
		-Dqt=true

		$(meson_use cue)

		$(meson_use mms)
		$(meson_use http neon)

		$(meson_use aac)
		-Dadplug=false
		$(meson_use fluidsynth amidiplug)
		$(meson_use cdda cdaudio)
		$(meson_use gme console)
		$(meson_use ffmpeg ffaudio)
		$(meson_use flac)
		$(meson_use modplug)
		$(meson_use mp3 mpg123)
		$(meson_use openmpt)
		$(meson_use opus)
		$(meson_use sid)
		$(meson_use sndfile)
		$(meson_use vorbis)
		$(meson_use wavpack)

		$(meson_use alsa)
		-Dcoreaudio=false
		$(meson_use flac filewriter-flac)
		$(meson_use lame filewriter-mp3)
		$(meson_use jack)
		-Doss=false
		$(meson_use pipewire)
		$(meson_use pulseaudio pulse)
		-Dqtaudio=true
		$(meson_use sdl sdlout)
		-Dsndio=false

		$(meson_use ampache)
		$(meson_use lirc)
		-Dmpris2=true
		$(meson_use libnotify notify)
		$(meson_use scrobbler scrobbler2)
		-Dsongchange=true
		$(meson_use streamtuner)

		$(meson_use bs2b)
		$(meson_use libsamplerate resample)
		$(meson_use soxr)
		$(meson_use speedpitch)

		$(meson_use opengl gl-spectrum)
		-Dvumeter=true

		-Dmoonstone=true
	)
	meson_src_configure
}
