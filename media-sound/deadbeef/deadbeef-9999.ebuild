# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/DeaDBeeF-Player/${PN}.git"
	EGIT_SUBMODULES=( external/mp4p )
	SRC_URI=""
else
	MY_PV="d2fc9ef"
	MY_MP="mp4p-a80941d"
	[[ -n ${PV%%*_p*} ]] && MY_PV="${PV}"
	SRC_URI="
		mirror://githubcl/DeaDBeeF-Player/${PN}/tar.gz/${MY_PV}
		-> ${P}.tar.gz
		mirror://githubcl/DeaDBeeF-Player/${MY_MP%-*}/tar.gz/${MY_MP##*-}
		-> ${MY_MP}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/${PN}-${MY_PV}"
fi
inherit autotools flag-o-matic xdg

DESCRIPTION="A music player for *nix-like systems and OSX"
HOMEPAGE="https://github.com/DeaDBeeF-Player/${PN}"
LICENSE="GPL-2 LGPL-2.1"

SLOT="0"
IUSE="
alsa oss pulseaudio gtk curl sid mad mac vorbis ffmpeg flac sndfile
wavpack cdda gme libnotify musepack midi tta dts aac mms libsamplerate X
zip nls threads gtk3 dumb shorten alac wma opus lastfm +clang
"
REQUIRED_USE="
	lastfm? ( curl clang )
	libnotify? ( clang )
"

RDEPEND="
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
	ffmpeg? ( media-video/ffmpeg )
	mad? ( media-libs/libmad )
	vorbis? ( media-libs/libvorbis )
	flac? ( media-libs/flac )
	wavpack? ( media-sound/wavpack )
	sndfile? ( media-libs/libsndfile )
	curl? ( net-misc/curl )
	cdda? ( dev-libs/libcdio media-libs/libcddb )
	gtk? ( x11-libs/gtk+:2 dev-libs/jansson:= )
	gtk3? ( x11-libs/gtk+:3 dev-libs/jansson:= )
	X? ( x11-libs/libX11 )
	pulseaudio? ( media-sound/pulseaudio )
	libsamplerate? ( media-libs/libsamplerate )
	musepack? ( media-sound/musepack-tools )
	aac? ( media-libs/faad2 )
	libnotify? ( x11-libs/libnotify sys-apps/dbus )
	zip? ( sys-libs/zlib dev-libs/libzip )
	gme? ( sys-libs/zlib )
	midi? ( media-sound/timidity-freepats )
	opus? ( media-libs/opusfile )
	clang? ( dev-libs/libdispatch )
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	sys-devel/gettext
	dev-util/intltool
	oss? ( virtual/libc )
	mac? ( dev-lang/yasm )
	clang? ( sys-devel/clang )
"
PATCHES=(
	"${FILESDIR}"/1bb94a3.patch
)

pkg_setup() {
	if use clang && ! tc-is-clang; then
		AR=llvm-ar
		CC=${CHOST}-clang
		CXX=${CHOST}-clang++
		NM=llvm-nm
		RANLIB=llvm-ranlib

		strip-unsupported-flags
	fi
}

src_prepare() {
	xdg_src_prepare
	if [[ -n ${PV%%*9999} ]]; then
		mv "${WORKDIR}"/${MY_MP}/* "${S}"/external/mp4p
	fi
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
		$(use_enable curl vfs-curl)
		$(use_enable lastfm lfm)
		$(use_enable sid)
		$(use_enable mad libmad)
		$(use_enable mac ffap)
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
	econf "${myconf[@]}"
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete
	docompress -x /usr/share/doc/${PF}
}
