# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/mpd-svn/mpd-svn-20051009-r1.ebuild,v 1.2 2005/10/17 14:42:41 ticho Exp $

inherit subversion autotools

DESCRIPTION="A development version of Music Player Daemon (mpd)"
HOMEPAGE="http://www.musicpd.org"
ESVN_REPO_URI="https://svn.musicpd.org/${PN}/trunk"
AT_M4DIR="m4"
ESVN_BOOTSTRAP="eautoreconf"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="aac alsa ao audiofile flac icecast ipv6 mad mikmod musepack vorbis oss
unicode ogg pulseaudio jack"

RDEPEND="
	!media-sound/mpd-svn
	!sys-cluster/mpich2
	sys-libs/zlib
	aac? ( >=media-libs/faad2-2.0_rc2 )
	alsa? ( media-sound/alsa-utils )
	ao? ( >=media-libs/libao-0.8.4 )
	audiofile? ( media-libs/audiofile )
	flac? ( >=media-libs/flac-1.1.0 )
	ogg? ( media-libs/libogg )
	icecast? ( media-libs/libshout )
	mad? ( media-libs/libmad
	       media-libs/libid3tag )
	mikmod? ( media-libs/libmikmod )
	musepack? ( media-libs/libmpcdec )
	pulseaudio? ( media-sound/pulseaudio )
	vorbis? ( media-libs/libvorbis )
	jack? ( media-sound/jack-audio-connection-kit )
"
DEPEND="
	${RDEPEND}
	oss? ( virtual/os-headers )
"

pkg_setup() {
	enewuser mpd '' '' "/var/lib/mpd" audio || die "problem adding user mpd"

	# also change the homedir if the user has existed before
	usermod -d "/var/lib/mpd" mpd
}

src_compile() {
	local myconf
	use ogg && myconf="${myconf} $(use_enable flac oggflac)"
	econf \
		$(use_enable alsa) \
		$(use_enable alsa alsatest) \
		$(use_enable jack) \
		$(use_enable oss) \
		$(use_enable aac) \
		$(use_enable ao) \
		$(use_enable ao aotest) \
		$(use_enable audiofile) \
		$(use_enable audiofile audiofiletest) \
		$(use_enable flac libFLACtest) \
		$(use_enable flac) \
		$(use_enable icecast shout) \
		$(use_enable ipv6) \
		$(use_enable mad mp3) \
		$(use_enable mad id3) \
		$(use_enable mikmod libmikmodtest) \
		$(use_enable mikmod mod) \
		$(use_enable musepack mpc) \
		$(use_enable pulseaudio pulse) \
		$(use_enable vorbis oggvorbis) \
		$(use_enable vorbis vorbistest) \
		${myconf} || die "could not configure"

	emake || die "emake failed"
}

src_install() {
	emake install DESTDIR=${D} || die
	rm -rf ${D}/usr/share/doc/mpd/
	dodoc ChangeLog INSTALL README TODO UPGRADING
	dodoc doc/COMMANDS doc/mpdconf.example

	insinto /etc
	newins doc/mpdconf.example mpd.conf

	newinitd ${FILESDIR}/mpd-0.12.rc6 mpd

	if use unicode; then
		dosed 's:^#filesystem_charset.*$:filesystem_charset "UTF-8":' /etc/mpd.conf
	fi
	dosed 's:^[#]*\(user[ \t]*\).*$:\1"mpd":' /etc/mpd.conf
	dosed 's:^\([#]*bind_to_address[ \t]*\).*$:\1"localhost":' /etc/mpd.conf
	dosed 's:^[#]*\(music_directory[ \t]*\).*$:\1"/var/lib/mpd/music":' /etc/mpd.conf
	dosed 's:^[#]*\(playlist_directory[ \t]*\).*$:\1"/var/lib/mpd/playlists":' /etc/mpd.conf
	dosed 's:^[#]*\(log_file[ \t]*\).*$:\1"/var/log/mpd/mpd.log":' /etc/mpd.conf
	dosed 's:^[#]*\(error_file[ \t]*\).*$:\1"/var/log/mpd/errors.log":' /etc/mpd.conf
	dosed 's:^[#]*\(pid_file[ \t]*\).*$:\1"/var/run/mpd/mpd.pid":' /etc/mpd.conf
	dosed 's:^[#]*\(db_file[ \t]*\).*:\1"/var/lib/mpd/database":' /etc/mpd.conf
	dosed 's:^\([#]*state_file[ \t]*\).*$:\1"/var/lib/mpd/state":' /etc/mpd.conf

	diropts -m0750 -o mpd -g audio
	dodir /var/lib/mpd/music
	keepdir /var/lib/mpd/music
	dodir /var/lib/mpd/playlists
	keepdir /var/lib/mpd/playlists
	dodir /var/run/mpd
	keepdir /var/run/mpd
	dodir /var/log/mpd
	keepdir /var/log/mpd

	use alsa && \
		dosed 's:need :need alsasound :' /etc/init.d/mpd
}

pkg_postinst() {
	elog "Home directory of user mpd, as well as default locations in mpd.conf have"
	elog "been changed to /var/lib/mpd, please bear that in mind while updating"
	elog "your mpd.conf file."
	elog ""
	elog "If you are upgrading from 0.11.x, check the configuration file carefully,"
	elog "the format has changed. See the example config file installed as"
	elog "/usr/share/doc/${PF}/mpdconf.example.gz, and mpd.conf manual page."
	elog ""
	elog "Please make sure that MPD's pid_file is set to /var/run/mpd/mpd.pid."
}
