# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/moc/moc-2.4.1.ebuild,v 1.2 2006/11/18 11:11:50 aballier Exp $

inherit subversion autotools

DESCRIPTION="Music On Console - ncurses interface for playing audio files"
HOMEPAGE="http://moc.daper.net/"
ESVN_REPO_URI="svn://daper.net/moc/trunk"
ESVN_BOOTSTRAP="autopoint && eautoreconf"
AT_M4DIR="m4"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86"
IUSE="
flac ffmpeg mad oss vorbis debug alsa speex libsamplerate curl sndfile musepack
jack modplug timidity wavpack nls
"

RDEPEND="
	media-libs/libao
	sys-libs/ncurses
	sys-libs/db
	alsa? ( >=media-libs/alsa-lib-0.9 )
	sndfile? ( >=media-libs/libsndfile-1.0.0 )
	flac? ( media-libs/flac )
	ffmpeg? ( media-video/ffmpeg )
	mad? ( media-libs/libmad sys-libs/zlib media-libs/libid3tag )
	musepack? ( media-libs/libmpcdec >=media-libs/taglib-1.3.1 )
	vorbis? ( >=media-libs/libvorbis-1.0 )
	speex? ( >=media-libs/speex-1.0.0 )
	libsamplerate? ( >=media-libs/libsamplerate-0.1.0 )
	curl? ( >=net-misc/curl-7.12.2 )
	jack? ( media-sound/jack-audio-connection-kit )
	modplug? ( media-libs/libmodplug )
	timidity? ( media-sound/timidity++ )
	wavpack? ( media-sound/wavpack )
"
DEPEND="
	${RDEPEND}
	sys-devel/gettext
"

src_compile() {
	econf --without-rcc \
		$(use_with flac) \
		$(use_with mad mp3) \
		$(use_with vorbis) \
		$(use_with oss) \
		$(use_with alsa) \
		$(use_with musepack) \
		$(use_with sndfile) \
		$(use_with libsamplerate samplerate) \
		$(use_enable debug) \
		$(use_with jack) \
		$(use_with modplug) \
		$(use_with timidity) \
		$(use_with wavpack) \
		$(use_with nls) \
		|| die "./configure failed"

	emake || die "make failed"
}

src_install () {
	emake DESTDIR="${D}" install || die "make install failed"
	rm -rf "${D}usr/share/doc/moc"
	dodoc AUTHORS ChangeLog NEWS README TODO *.example
}

pkg_postinst() {
	einfo "The binary was renamed due to conflicts with moc"
	einfo "from the QT project. Its new name is mocp."
}
