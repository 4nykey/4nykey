# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit subversion autotools

DESCRIPTION="Aqualung"
HOMEPAGE="http://aqualung.sourceforge.net"
SRC_URI=""
ESVN_REPO_URI="https://aqualung.svn.sourceforge.net/svnroot/aqualung/trunk"
ESVN_PATCHES="${PN}-*.diff"
ESVN_BOOTSTRAP="eautoreconf"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="
oss alsa jack libsamplerate sndfile flac vorbis speex mp3 modplug musepack ape
taglib ladspa cdda cddb ifp systray encode ffmpeg wavpack
"

RDEPEND="
	>=x11-libs/gtk+-2.6
	dev-libs/libxml2
	alsa? ( media-libs/alsa-lib )
	jack? ( media-sound/jack-audio-connection-kit )
	libsamplerate? ( media-libs/libsamplerate )
	sndfile? ( >=media-libs/libsndfile-1.0.12 )
	flac? ( media-libs/flac )
	vorbis? ( media-libs/libvorbis )
	speex? ( media-libs/speex media-libs/liboggz )
	mp3? (
		media-libs/id3lib
		media-libs/libmad
		encode? ( media-sound/lame )
	)
	modplug? ( >=media-libs/libmodplug-0.8 )
	musepack? ( media-libs/libmpcdec )
	ape? ( media-sound/mac )
	ffmpeg? ( media-video/ffmpeg )
	wavpack? ( >=media-sound/wavpack-4.40 )
	taglib? ( >=media-libs/taglib-1.4 )
	ladspa? ( >=media-libs/liblrdf-0.4.0 )
	cdda? ( >=dev-libs/libcdio-0.76 )
	cddb? ( >=media-libs/libcddb-1.2.1 )
	ifp? ( media-libs/libifp )
	systray? ( >=x11-libs/gtk+-2.10 )
"
DEPEND="
	${RDEPEND}
	oss? ( virtual/os-headers )
	>=dev-util/pkgconfig-0.9.0
"

src_compile() {
	local myconf
	if use encode; then
		myconf="${myconf} $(use_with vorbis vorbisenc)"
		myconf="${myconf} $(use_with mp3 lame)"
	fi

	econf \
		$(use_with oss) \
		$(use_with alsa) \
		$(use_with jack) \
		$(use_with sndfile) \
		$(use_with libsamplerate src) \
		$(use_with flac) \
		$(use_with vorbis ogg) \
		$(use_with speex) \
		$(use_with mp3 mpeg) \
		$(use_with mp3 id3) \
		$(use_with mp3 mpegstatrec) \
		$(use_with modplug mod) \
		$(use_with musepack mpc) \
		$(use_with ape mac) \
		$(use_with ffmpeg lavc) \
		$(use_with wavpack) \
		$(use_with taglib metadata) \
		$(use_with taglib metaedit) \
		$(use_with ladspa) \
		$(use_with cdda) \
		$(use_with cddb) \
		$(use_with ifp) \
		$(use_with systray) \
		|| die "econf failed"

	emake || die "make failed"
}

src_install() {
	einstall || die "einstall failed"
	dodoc AUTHORS ChangeLog README
}
