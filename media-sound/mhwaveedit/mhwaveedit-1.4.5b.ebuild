# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/mhwaveedit/mhwaveedit-1.3.3.ebuild,v 1.4 2004/12/19 05:54:40 eradicator Exp $

IUSE="gtk2 oss sdl sndfile portaudio alsa jack esd arts"

DESCRIPTION="GTK2 Sound file editor (wav, and a few others.)"
SRC_URI="http://download.gna.org/${PN}/${P}.tar.bz2"
HOMEPAGE="https://gna.org/projects/mhwaveedit/"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="amd64 sparc x86"

DEPEND="gtk2? ( >=x11-libs/gtk+-2.0.0 )
	!gtk2? ( =x11-libs/gtk+-1.2* )
	sdl? ( >=media-libs/libsdl-1.2.3 )
	sndfile? ( >=media-libs/libsndfile-1.0.10 )
	portaudio? ( >=media-libs/portaudio-18 )
	jack? ( >=media-sound/jack-audio-connection-kit-0.98.0 )
	esd? ( >=media-sound/esound-0.2.0 )
	arts? ( kde-base/arts )
	alsa? ( virtual/os-headers )"

src_compile() {
	econf \
		`use_enable gtk2` \
		`use_with oss` \
		`use_with sdl` \
		`use_with sndfile libsndfile` \
		`use_with portaudio` \
		`use_with alsa alsalib` \
		`use_with jack` \
		`use_with arts` \
		`use_with esd esound` || die
	emake || die
}

src_install() {
	einstall || die
	dodoc ChangeLog AUTHORS README* NEWS BUGS
}
