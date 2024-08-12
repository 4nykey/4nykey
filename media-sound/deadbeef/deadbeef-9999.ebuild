# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/DeaDBeeF-Player/${PN}.git"
	EGIT_SUBMODULES=( external/mp4p )
	SRC_URI=""
else
	MY_PV="d4cca56"
	MY_MP="mp4p-156195c"
	MY_LR="ddb_dsp_libretro-b4d3db1"
	MY_PW="ddb_output_pw-0b099d1"
	[[ -n ${PV%%*_p*} ]] && MY_PV="${PV}"
	SRC_URI="
		mirror://githubcl/DeaDBeeF-Player/${PN}/tar.gz/${MY_PV}
		-> ${P}.tar.gz
		mirror://githubcl/DeaDBeeF-Player/${MY_MP%-*}/tar.gz/${MY_MP##*-}
		-> ${MY_MP}.tar.gz
		mirror://githubcl/DeaDBeeF-Player/${MY_LR%-*}/tar.gz/${MY_LR##*-}
		-> ${MY_LR}.tar.gz
		mirror://githubcl/DeaDBeeF-Player/${MY_PW%-*}/tar.gz/${MY_PW##*-}
		-> ${MY_PW}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/${PN}-${MY_PV}"
fi
inherit autotools flag-o-matic toolchain-funcs xdg

DESCRIPTION="A music player for *nix-like systems and OSX"
HOMEPAGE="https://deadbeef.sourceforge.io"
LICENSE="GPL-2 LGPL-2.1"

SLOT="0"
IUSE="
X aac adplug alac alsa artwork cdda curl dts dumb ffmpeg flac gme gtk gtk3
lastfm libnotify libretro libsamplerate mac mad midi mms musepack nls opus
oss pipewire psf pulseaudio sc68 shorten sid sndfile threads tta vorbis
wavpack wma zip
"
REQUIRED_USE="
	lastfm? ( curl )
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
	ffmpeg? ( media-video/ffmpeg:= )
	mad? ( media-libs/libmad:= )
	vorbis? ( media-libs/libvorbis )
	flac? ( media-libs/flac )
	wavpack? ( media-sound/wavpack )
	sndfile? ( media-libs/libsndfile )
	curl? ( net-misc/curl )
	cdda? ( dev-libs/libcdio media-libs/libcddb )
	gtk? ( x11-libs/gtk+:2 dev-libs/jansson:= )
	gtk3? ( x11-libs/gtk+:3 dev-libs/jansson:= )
	X? ( x11-libs/libX11 )
	pulseaudio? ( media-libs/libpulse )
	libsamplerate? ( media-libs/libsamplerate )
	musepack? ( media-sound/musepack-tools )
	aac? ( media-libs/faad2 )
	libnotify? ( x11-libs/libnotify sys-apps/dbus )
	zip? ( sys-libs/zlib dev-libs/libzip )
	gme? ( sys-libs/zlib )
	psf? ( sys-libs/zlib )
	midi? ( media-sound/timidity-freepats )
	opus? ( media-libs/opusfile )
	dev-libs/libdispatch
	pipewire? ( media-video/pipewire:= )
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	sys-devel/gettext
	dev-util/intltool
	oss? ( virtual/libc )
	mac? ( dev-lang/yasm )
	sys-devel/clang
"

pkg_setup() {
	if ! tc-is-clang; then
		AR=llvm-ar
		CC=${CHOST}-clang
		CXX=${CHOST}-clang++
		NM=llvm-nm
		RANLIB=llvm-ranlib
		strip-unsupported-flags
	fi
}

src_prepare() {
	default
	if [[ -n ${PV%%*9999} ]]; then
		mv "${WORKDIR}"/${MY_MP}/* "${S}"/external/${MY_MP%-*}
		mv "${WORKDIR}"/${MY_LR}/* "${S}"/external/${MY_LR%-*}
		mv "${WORKDIR}"/${MY_PW}/* "${S}"/external/${MY_PW%-*}
	fi
	local _t=/usr/share/timidity/freepats/timidity.cfg
	sed \
		-e "s,#define DEFAULT_TIMIDITY_CONFIG \",&${_t}:," \
		-i plugins/wildmidi/wildmidiplug.c
	sed -e 's:Toggle Pause:Toggle-Pause:' -i deadbeef.desktop.in
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
		$(use_enable libretro)
		$(use_enable pipewire)
		$(use_enable adplug)
		$(use_enable artwork)
		--enable-artwork-network=$(usex artwork $(usex curl))
		$(use_enable psf)
		$(use_enable sc68)
	)
	econf "${myconf[@]}"
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete
	docompress -x /usr/share/doc/${PF}
}
