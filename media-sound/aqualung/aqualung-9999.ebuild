# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit cvs autotools

DESCRIPTION="Aqualung"
HOMEPAGE="http://aqualung.sourceforge.net"
SRC_URI=""
ECVS_SERVER="aqualung.cvs.sourceforge.net:/cvsroot/aqualung"
ECVS_MODULE="aqualung"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="oss alsa jack libsamplerate sndfile flac vorbis speex mp3 modplug musepack
ape taglib ladspa cddb pda systray"

RDEPEND="
	>=x11-libs/gtk+-2.6
	dev-libs/libxml2
	alsa? ( media-libs/alsa-lib )
	jack? ( media-sound/jack-audio-connection-kit )
	libsamplerate? ( media-libs/libsamplerate )
	sndfile? ( media-libs/libsndfile )
	flac? ( media-libs/flac )
	vorbis? ( media-libs/libvorbis )
	speex? ( media-libs/speex media-libs/liboggz )
	mp3? ( media-libs/id3lib media-libs/libmad )
	modplug? ( >=media-libs/libmodplug-0.8 )
	musepack? ( media-libs/libmpcdec )
	ape? ( media-sound/mac )
	taglib? ( >=media-libs/taglib-1.4 )
	ladspa? ( >=media-libs/liblrdf-0.4.0 )
	cddb? ( >=media-libs/libcddb-1.2.1 )
	pda? ( media-libs/libifp )
	systray? ( >=x11-libs/gtk+-2.10 )
"
DEPEND="
	${RDEPEND}
	oss? ( virtual/os-headers )
	>=dev-util/pkgconfig-0.9.0
"

S="${WORKDIR}/${ECVS_MODULE}"

src_unpack() {
	cvs_src_unpack
	cd ${S}
	# respect my cflagz
	sed -i "s:-O2:${CFLAGS}:" configure.ac
	eautoreconf
}

src_compile() {
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
		$(use_with taglib metadata) \
		$(use_with taglib metaedit) \
		$(use_with ladspa) \
		$(use_with cddb) \
		$(use_with pda ifp) \
		$(use_with systray) \
		|| die "econf failed"
	emake || die "make failed"
}

src_install() {
	einstall || die "einstall failed"
} 
