# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/sweep/sweep-0.8.3.ebuild,v 1.9 2005/12/26 14:16:50 lu_zero Exp $

inherit eutils

DESCRIPTION="audio editor and live playback tool"
HOMEPAGE="http://www.metadecks.org/software/sweep/"
SRC_URI="http://www.metadecks.org/software/sweep/download/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 ppc sparc x86"
IUSE="alsa nls vorbis mad speex libsamplerate"

DEPEND="dev-libs/tdb
	libsamplerate? ( media-libs/libsamplerate )
	>=media-libs/libsndfile-1.0
	speex? ( media-libs/speex )
	mad? ( >=media-sound/madplay-0.14.2b )
	>=x11-libs/gtk+-2.2.0
	alsa? ( >=media-libs/alsa-lib-1.0.0 )
	nls? ( sys-devel/gettext )
	vorbis? ( media-libs/libogg media-libs/libvorbis )"

src_unpack() {
	unpack ${A}
	cd ${S}
#	epatch ${FILESDIR}/${P}-alsa.patch
}

src_compile() {
	econf \
		--enable-experimental \
		$(use_enable alsa) \
		$(use_enable nls) \
		$(use_enable vorbis oggvorbis) \
		$(use_enable speex) \
		$(use_enable mad) \
		$(use_enable libsamplerate src) \
		|| die "econf failed"

	emake || die "make failed"
}

src_install() {
	einstall || die "make install failed"
}

pkg_postinst() {
	einfo
	einfo "Sweep can use ladspa plugins,"
	einfo "emerge ladspa-sdk and ladspa-cmt if you want them."
	einfo
}
