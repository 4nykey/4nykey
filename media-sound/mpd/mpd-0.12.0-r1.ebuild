# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/mpd-svn/mpd-svn-20051009-r1.ebuild,v 1.2 2005/10/17 14:42:41 ticho Exp $

inherit subversion autotools

DESCRIPTION="A development version of Music Player Daemon (mpd)"
HOMEPAGE="http://www.musicpd.org"
#SRC_URI="mirror://gentoo/${P}.tar.bz2"
ESVN_REPO_URI="https://svn.musicpd.org/${PN}/trunk"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="aac alsa libao audiofile flac icecast ipv6 mad mikmod mp3 musepack vorbis
oss unicode ogg"

DEPEND="dev-util/gperf
	sys-libs/zlib
	aac? ( >=media-libs/faad2-2.0_rc2 )
	alsa? ( media-libs/alsa-lib )
	ao? ( >=media-libs/libao-0.8.4 )
	audiofile? ( media-libs/audiofile )
	flac? ( >=media-libs/flac-1.1.0 )
	ogg? ( media-libs/libogg )
	icecast? ( media-libs/libshout )
	mad? ( media-libs/libmad
	       media-libs/libid3tag )
	mikmod? ( media-libs/libmikmod )
	musepack? ( media-libs/libmpcdec )
	vorbis? ( media-libs/libvorbis )"

upgrade_warning() {
	echo
	ewarn "This package now correctly uses 'vorbis' USE flag, instead of 'ogg'."
	ewarn "See http://bugs.gentoo.org/show_bug.cgi?id=101877 for details."
	echo
	ewarn "Home directory of user mpd, as well as default locations in mpd.conf have"
	ewarn "been changed to /var/lib/mpd, please bear that in mind while updating"
	ewarn "your mpd.conf file."
	echo
	epause 7
}

pkg_setup() {
	upgrade_warning
	enewuser mpd '' '' "/var/lib/mpd" audio || die "problem adding user mpd"

	# also change the homedir if the user has existed before
	usermod -d "/var/lib/mpd" mpd
}

src_unpack() {
	subversion_src_unpack
	cd ${S}
	has_version '>=media-libs/faad2-2.1' && \
		sed -i 's:faacDec:NeAACDec:g; s:MP4FF_.*la:MP4FF_LIB="-lmp4ff:' configure.ac
	eautoreconf || die
}

src_compile() {
	local myconf
	use ogg && myconf="${myconf} $(use_enable flac oggflac)"
	econf \
		$(use_enable alsa) \
		$(use_enable oss) \
		$(use_enable mp3) \
		$(use_enable aac) \
		$(use_enable libao ao) \
		$(use_enable audiofile) \
		$(use_enable flac) \
		$(use_enable icecast shout) \
		$(use_enable ipv6) \
		$(use_enable !mad mpd-mad) \
		$(use_enable !mad mpd-id3tag) \
		$(use_enable mikmod mod) \
		$(use_enable musepack mpc) \
		$(use_enable vorbis oggvorbis) \
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

	exeinto /etc/init.d
	newexe ${FILESDIR}/mpd.rc6 mpd

	if use unicode; then
		dosed 's:^#filesystem_charset.*$:filesystem_charset "UTF-8":' /etc/mpd.conf
	fi
	dosed 's:^\(#user[ \t]*\).*$:\1"mpd":' /etc/mpd.conf
	dosed 's:^\(#bind_to_address[ \t]*\).*$:\1"localhost":' /etc/mpd.conf
	dosed 's:^\(port[ \t]*\).*$:\1"6600":' /etc/mpd.conf
	dosed 's:^\(music_directory[ \t]*\).*$:\1"/var/lib/mpd/music":' /etc/mpd.conf
	dosed 's:^\(playlist_directory[ \t]*\).*$:\1"/var/lib/mpd/playlists":' /etc/mpd.conf
	dosed 's:^\(log_file[ \t]*\).*$:\1"/var/log/mpd/mpd.log":' /etc/mpd.conf
	dosed 's:^\(error_file[ \t]*\).*$:\1"/var/log/mpd/errors.log":' /etc/mpd.conf
	dosed 's:^\(pid_file[ \t]*\).*$:\1"/var/run/mpd/mpd.pid":' /etc/mpd.conf
	dosed 's:^\(db_file[ \t]*\).*:\1"/var/lib/mpd/database":' /etc/mpd.conf
	dosed 's:^\(#state_file[ \t]*\).*$:\1"/var/lib/mpd/state":' /etc/mpd.conf

	diropts -m0755 -o mpd -g audio
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
	echo
	einfo "The default config now binds the daemon strictly to localhost,"
	einfo "rather than to all available IPs."
	echo
	if ! use libao ; then
		ewarn "As you're not using libao for audio output, you need to"
		ewarn "adjust audio_output sections in /etc/mpd.conf to use"
		ewarn "ALSA or OSS. See"
		ewarn "/usr/share/doc/${PF}/mpdconf.example.gz."
		echo
	fi
	einfo "Please make sure that MPD's pid_file is set to /var/run/mpd/mpd.pid."
	echo
	draw_line
	ewarn "Note that this is just a development version of Music Player Daemon,"
	ewarn "so if you want to report any bug to MPD developers, please state this fact in"
	ewarn "your bug report, as well as the fact that you used a ${P} Gentoo ebuild."
	draw_line
	upgrade_warning
}
