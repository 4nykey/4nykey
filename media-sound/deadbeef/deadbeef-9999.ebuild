# Copyright 2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit autotools-utils gnome2 git-r3

EGIT_REPO_URI="https://github.com/Alexey-Yakovenko/deadbeef.git"

DESCRIPTION="DeaDBeeF - Ultimate Music Player For GNU/Linux"
HOMEPAGE="http://deadbeef.sourceforge.net"
SRC_URI=""
LICENSE="GPL-2 LGPL-2.1"

SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="
alsa oss pulseaudio gtk network sid mad mac adplug vorbis ffmpeg flac sndfile
wavpack cdda gme libnotify musepack midi tta dts aac mms libsamplerate X cover
zip nls threads pth gtk3
"

# come bundled
RDEPEND="
	adplug? ( media-libs/adplug )
	dts? ( media-libs/libdca )
	mac? ( media-sound/mac )
	gme? ( media-libs/game-music-emu )
	mms? ( media-libs/libmms )
	sid? ( media-sound/sidplay )
	tta? ( media-sound/ttaenc )
	midi? ( media-sound/wildmidi )
"
# real deps
RDEPEND="
	alsa? ( media-libs/alsa-lib )
	ffmpeg? ( virtual/ffmpeg )
	mad? ( media-libs/libmad )
	vorbis? ( media-libs/libvorbis )
	flac? ( media-libs/flac )
	wavpack? ( media-sound/wavpack )
	sndfile? ( media-libs/libsndfile )
	network? ( net-misc/curl )
	cdda? ( dev-libs/libcdio media-libs/libcddb )
	gtk? ( x11-libs/gtkglext )
	gtk3? ( x11-libs/gtk+:3 )
	X? ( x11-libs/libX11 )
	pulseaudio? ( media-sound/pulseaudio )
	cover? ( media-libs/imlib2 )
	libsamplerate? ( media-libs/libsamplerate )
	musepack? ( media-sound/musepack-tools )
	aac? ( media-libs/faad2 )
	libnotify? ( x11-libs/libnotify sys-apps/dbus )
	zip? ( sys-libs/zlib dev-libs/libzip )
	pth? ( dev-libs/pth )
	gme? ( sys-libs/zlib )
	midi? ( media-sound/timidity-freepats )
"
DEPEND="
	${RDEPEND}
	oss? ( virtual/libc )
"
G2CONF="
	$(use_enable nls)
	$(use_enable threads threads $(usex pth pth posix))
	$(use_enable alsa)
	$(use_enable oss)
	$(use_enable pulseaudio pulse)
	$(use_enable gtk gtk2)
	$(use_enable gtk3)
	$(use_enable network vfs-curl)
	$(use_enable network lfm)
	$(use_enable cover artwork)
	$(use_enable sid)
	$(use_enable mad)
	$(use_enable mac ffap)
	$(use_enable adplug)
	$(use_enable X hotkeys)
	$(use_enable vorbis)
	$(use_enable ffmpeg)
	$(use_enable flac)
	$(use_enable sndfile)
	$(use_enable wavpack)
	$(use_enable cdda )
	$(use_enable gme)
	$(use_enable libnotify notify)
	$(use_enable musepack)
	$(use_enable midi wildmidi)
	$(use_enable tta)
	$(use_enable dts dca)
	$(use_enable aac)
	$(use_enable mms)
	$(use_enable libsamplerate src)
	$(use_enable zip vfs-zip)
"

AUTOTOOLS_AUTORECONF="1"
AUTOTOOLS_IN_SOURCE_BUILD="1"
AUTOTOOLS_PRUNE_LIBTOOL_FILES="modules"

src_prepare() {
	sed -i "${S}"/plugins/wildmidi/wildmidiplug.c \
		-e 's,#define DEFAULT_TIMIDITY_CONFIG ",&/usr/share/timidity/freepats/timidity.cfg:,'
	eautopoint --force
	autotools-utils_src_prepare
}

src_install() {
	autotools-utils_src_install
	docompress -x /usr/share/doc/${PF}
}
