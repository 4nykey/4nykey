# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/DeaDBeeF-Player/${PN}.git"
	EGIT_SUBMODULES=( )
	SRC_URI=""
else
	MY_PV="${PV}"
	if [[ -z ${PV%%*_p*} ]]; then
		inherit vcs-snapshot
		MY_PV="d2fc9ef"
	fi
	SRC_URI="
		mirror://githubcl/DeaDBeeF-Player/${PN}/tar.gz/${MY_PV}
		-> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi
inherit autotools xdg

DESCRIPTION="A music player for *nix-like systems and OSX"
HOMEPAGE="https://github.com/DeaDBeeF-Player/${PN}"
LICENSE="GPL-2 LGPL-2.1"

SLOT="0"
IUSE="
alsa oss pulseaudio gtk network sid mad mac adplug vorbis ffmpeg flac sndfile
wavpack cdda gme libnotify musepack midi tta dts aac mms libsamplerate X imlib
zip nls threads gtk3 dumb shorten alac wma opus
"

RDEPEND="
	adplug? ( media-libs/adplug )
	dts? ( media-libs/libdca )
	mac? ( media-sound/mac )
	gme? ( media-libs/game-music-emu )
	mms? ( media-libs/libmms )
	tta? ( media-sound/ttaenc )
	midi? ( media-sound/wildmidi )
	dumb? ( media-libs/dumb )
	shorten? ( media-sound/shorten )
	alac? ( media-sound/alac_decoder )
	alsa? ( media-libs/alsa-lib )
	ffmpeg? ( virtual/ffmpeg )
	mad? ( media-libs/libmad )
	vorbis? ( media-libs/libvorbis )
	flac? ( media-libs/flac )
	wavpack? ( media-sound/wavpack )
	sndfile? ( media-libs/libsndfile )
	network? ( net-misc/curl )
	cdda? ( dev-libs/libcdio media-libs/libcddb )
	gtk? ( x11-libs/gtk+:2 dev-libs/jansson )
	gtk3? ( x11-libs/gtk+:3 dev-libs/jansson )
	X? ( x11-libs/libX11 )
	pulseaudio? ( media-sound/pulseaudio )
	imlib? ( media-libs/imlib2[jpeg,png] )
	libsamplerate? ( media-libs/libsamplerate )
	musepack? ( media-sound/musepack-tools )
	aac? ( media-libs/faad2 )
	libnotify? ( x11-libs/libnotify sys-apps/dbus )
	zip? ( sys-libs/zlib dev-libs/libzip )
	gme? ( sys-libs/zlib )
	midi? ( media-sound/timidity-freepats )
	opus? ( media-libs/opusfile )
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	sys-devel/gettext
	dev-util/intltool
	oss? ( virtual/libc )
	mac? ( dev-lang/yasm )
"

src_prepare() {
	default
	local _t=/usr/share/timidity/freepats/timidity.cfg
	sed \
		-e "s,#define DEFAULT_TIMIDITY_CONFIG \",&${_t}:," \
		-i plugins/wildmidi/wildmidiplug.c
	eautopoint --force
	eautoreconf
}

src_configure() {
	local myconf=(
		$(use_enable nls)
		$(use_enable threads)
		$(use_enable alsa)
		$(use_enable oss)
		$(use_enable pulseaudio pulse)
		$(use_enable gtk gtk2)
		$(use_enable gtk3)
		$(use_enable network vfs-curl)
		$(use_enable network lfm)
		$(use_enable imlib artwork)
		$(use_enable sid)
		$(use_enable mad libmad)
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
		$(use_enable dumb)
		$(use_enable shorten shn)
		$(use_enable alac)
		$(use_enable wma)
		$(use_enable opus)
	)
	use imlib && myconf+=( $(use_enable network artwork-network) )
	econf "${myconf[@]}"
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete
	docompress -x /usr/share/doc/${PF}
}
