# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/moc/moc-2.3.0.ebuild,v 1.2 2005/07/14 08:53:48 dholm Exp $

inherit eutils

MY_P="${P/_/-}"
DESCRIPTION="Music On Console - ncurses interface for playing audio files"
HOMEPAGE="http://moc.daper.net/"
SRC_URI="ftp://ftp.daper.net/pub/soft/${PN}/unstable/${MY_P}.tar.bz2"
S="${WORKDIR}/moc-DEVEL"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE="flac mad vorbis musepack speex libsamplerate jack curl"

DEPEND="media-libs/libao
	media-libs/libsndfile
	sys-libs/ncurses
	flac? ( media-libs/flac )
	mad? ( media-libs/libmad sys-libs/zlib media-libs/libid3tag )
	musepack? ( media-libs/libmpcdec )
	speex? ( >=media-libs/speex-1.0.0 )
	libsamplerate? ( >=media-libs/libsamplerate-0.1.0 )
	jack? ( >=media-sound/jack-audio-connection-kit-0.4 )
	curl? ( >=net-misc/curl-7.12.0 )
	vorbis? ( media-libs/libvorbis )"

src_compile() {
	local myconf
	use flac || myconf="${myconf} --without-flac"
	use mad || myconf="${myconf} --without-mp3"
	use vorbis || myconf="${myconf} --without-ogg"
	use musepack || myconf="${myconf} --without-musepack"
	use speex || myconf="${myconf} --without-speex"
	use libsamplerate || myconf="${myconf} --without-samplerate"
	use jack || myconf="${myconf} --without-jack"
	use curl || myconf="${myconf} --without-curl"

	econf ${myconf} || die "./configure failed"
	emake || die "make failed"
}

src_install () {
	make DESTDIR="${D}" install || die "make install failed"
	dodoc AUTHORS ChangeLog NEWS README TODO
}

pkg_postinst() {
	einfo "The binary was renamed due to conflicts with moc"
	einfo "from the QT project. Its new name is mocp."
}
