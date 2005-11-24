# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/mpd/mpd-0.11.5.ebuild,v 1.3 2005/01/21 20:29:46 pylon Exp $

IUSE="vorbis mad aac audiofile ipv6 flac mikmod alsa unicode musepack"

inherit subversion

DESCRIPTION="Music Player Daemon (mpd)"
HOMEPAGE="http://www.musicpd.org"
#SRC_URI="http://mercury.chem.pitt.edu/~shank/${P}.tar.gz"
ESVN_REPO_URI="https://svn.musicpd.org/${PN}/trunk"
ESVN_BOOTSTRAP="./autogen.sh"
ESVN_PATCHES="*.diff"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86"

DEPEND="vorbis? ( media-libs/libvorbis )
	mad? ( media-libs/libmad
	       media-libs/libid3tag )
	aac? ( media-libs/faad2 )
	audiofile? ( media-libs/audiofile )
	flac? ( >=media-libs/flac-1.1.0 )
	mikmod? ( media-libs/libmikmod )
	alsa? ( media-libs/alsa-lib )
	musepack? ( media-libs/libmpcdec )
	>=media-libs/libao-0.8.4
	>=dev-libs/glib-2.0.0
	sys-libs/zlib"

pkg_setup() {
	enewuser mpd '' '' '' audio || die "problem adding user mpd"
}

src_unpack() {
	subversion_svn_fetch
	has_version '>=media-libs/faad2-2.1' && \
		sed -i 's:faacDec:NeAACDec:g; s:MP4FF_.*la:MP4FF_LIB="-lmp4ff:' ${S}/configure.ac
	subversion_bootstrap
}

src_compile() {
	econf `use_enable aac` \
		`use_enable !mad mpd-mad` \
		`use_enable !mad mpd-id3tag` \
		`use_enable vorbis ogg` \
		`use_enable vorbis oggtest` \
		`use_enable vorbis vorbistest` \
		`use_enable audiofile` \
		`use_enable audiofile audiofiletest` \
		`use_enable ipv6` \
		`use_enable flac libFLACtest` \
		`use_enable flac` \
		`use_enable musepack mpc` \
		`use_enable mikmod libmikmodtest` \
		`use_enable mikmod mod` ${myconf} ||
		die "could not configure"

	emake || die "emake failed"
}

src_install() {
	emake install DESTDIR=${D} || die
	rm -rf ${D}/usr/share/doc/mpd/
	dodoc COPYING ChangeLog INSTALL README TODO UPGRADING
	dodoc doc/COMMANDS doc/mpdconf.example

	insinto /etc
	newins doc/mpdconf.example mpd.conf

	exeinto /etc/init.d
	newexe ${FILESDIR}/mpd.rc7 mpd

	if use unicode; then
		dosed 's:^#filesystem_charset.*$:filesystem_charset "UTF-8":' /etc/mpd.conf
	fi
	dosed 's:^#user\([ \t]*\).*$:user\1"mpd":' /etc/mpd.conf
	dosed 's:^#bind_to_address\([ \t]*\).*$:bind_to_address\1"localhost":' /etc/mpd.conf
	dosed 's:^port\([ \t]*\).*$:port\1"6600":' /etc/mpd.conf
	dosed 's:^music_directory\([ \t]*\).*$:music_directory\1"/usr/share/mpd/music":' /etc/mpd.conf
	dosed 's:^playlist_directory\([ \t]*\).*$:playlist_directory\1"/usr/share/mpd/playlists":' /etc/mpd.conf
	dosed 's:^db_file\([ \t]*\).*$:db_file\1"/usr/share/mpd/mpd.db":' /etc/mpd.conf
	dosed 's:^log_file\([ \t]*\).*$:log_file\1"/var/log/mpd.log":' /etc/mpd.conf
	dosed 's:^error_file\([ \t]*\).*$:error_file\1"/var/log/mpd.error.log":' /etc/mpd.conf
	dosed 's:^pid_file\([ \t]*\).*$:pid_file\1"/var/run/mpd/mpd.pid":' /etc/mpd.conf
	dosed 's:\~/\.mpd/mpdstate:/usr/share/mpd/mpdstate:' /etc/mpd.conf
	diropts -m0755 -o mpd -g audio
	dodir /usr/share/mpd/music
	keepdir /usr/share/mpd/music
	dodir /usr/share/mpd/playlists
	keepdir /usr/share/mpd/playlists
	dodir /usr/share/mpd/
	dodir /var/run/mpd
	keepdir /var/run/mpd
	insinto /var/log
	touch ${T}/blah
	insopts -m0640 -o mpd -g audio
	newins ${T}/blah mpd.log
	newins ${T}/blah mpd.error.log
}

pkg_postinst() {
	einfo "libao prior to 0.8.4 has issues with the ALSA drivers"
	einfo "please refer to the FAQ"
	einfo "http://www.musicpd.org/wiki/moin.cgi/MpdFAQ if you are having problems."
	einfo
	einfo "The default config now binds the daemon strictly to localhost, rather then all available IPs."
}
