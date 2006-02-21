# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/audacious/audacious-0.2-r1.ebuild,v 1.4 2006/02/19 18:30:16 hansmi Exp $

IUSE="aac adplug alsa esd flac gnome jack libvisual lirc mmx modplug mp3 musepack nls oss sdl sid sndfile vorbis wma"

inherit flag-o-matic subversion autotools

DESCRIPTION="Audacious Player - Your music, your way, no exceptions."
HOMEPAGE="http://audacious-media-player.org/"
#SRC_URI="mirror://gentoo/gentoo_ice-xmms-0.2.tar.bz2"
ESVN_REPO_URI="http://svn.atheme.org/audacious/trunk"

LICENSE="GPL-2"
SLOT="0"

KEYWORDS="~x86"

RDEPEND="app-arch/unzip
	>=x11-libs/gtk+-2.6
	>=gnome-base/libglade-2.3.1
	adplug? ( media-libs/adplug )
	alsa? ( >=media-libs/alsa-lib-1.0.9_rc2 )
	esd? ( >=media-sound/esound-0.2.30 )
	flac? ( >=media-libs/libvorbis-1.0
		>=media-libs/flac-1.1.2 )
	gnome? ( >=gnome-base/gconf-2.6.0
		>=gnome-base/gnome-vfs-2.6.0 )
	jack? ( >=media-libs/bio2jack-0.4
		media-libs/libsamplerate
		media-sound/jack-audio-connection-kit )
	libvisual? ( =media-plugins/libvisual-plugins-0.2.0
		     >=media-libs/libsdl-1.2.5 )
	lirc? ( app-misc/lirc )
	modplug? ( media-libs/libmodplug )
	musepack? ( media-libs/libmpcdec
		    media-libs/taglib )
	mp3? ( media-libs/id3lib )
	sid? ( media-libs/libsidplay )
	sndfile? ( media-libs/libsndfile )
	aac? ( media-libs/faad2
		|| ( media-libs/libmp4v2 media-video/mpeg4ip-cvs ) )
	vorbis? ( >=media-libs/libvorbis-1.0
		  >=media-libs/libogg-1.0 )"

DEPEND="${RDEPEND}
	sys-devel/gettext
	nls? ( dev-util/intltool )
	>=dev-util/pkgconfig-0.9.0"

src_unpack() {
	subversion_src_unpack
	cd ${S}
	epatch ${FILESDIR}/*.diff
	autopoint --force || die
	AT_M4DIR="${S}/m4" eautoreconf || die
	automake --add-missing --copy || die
}

src_compile() {
	if ! use mp3; then
		ewarn "MP3 support is now optional and you have not enabled it."
	fi

	# Bug #42893
	replace-flags "-Os" "-O2"
	# Bug #86689
	is-flag "-O*" || append-flags -O

	econf \
		--with-dev-dsp=/dev/sound/dsp \
		--with-dev-mixer=/dev/sound/mixer \
		--includedir=/usr/include/audacious \
		`use_enable mmx simd` \
		`use_enable gnome gconf` \
		`use_enable vorbis` \
		`use_enable esd` \
		`use_enable mp3` \
		`use_enable nls` \
		`use_enable oss` \
		`use_enable alsa` \
		`use_enable flac` \
		`use_enable aac` \
		`use_enable modplug` \
		`use_enable lirc` \
		`use_enable sndfile` \
		`use_enable wma` \
		`use_enable sid` \
		`use_enable musepack` \
		`use_enable jack` \
		`use_enable adplug` \
		|| die
#		`use_enable gnome gnome-vfs` \

	make || die "make failed"
}

src_install() {
	einstall || die
	dodoc AUTHORS NEWS README

	# XMMS skin symlinking; bug 70697
	for SKIN in /usr/share/xmms/Skins/* ; do
		dosym "$SKIN" /usr/share/audacious/Skins/
	done

	insinto /usr/share/applications
	doins audacious/audacious.desktop
}

pkg_postinst() {
	echo
	einfo "Your XMMS skins, if any, have been symlinked."
	einfo "MP3 support is now optional, you may want to enable the mp3 USE-flag."
	echo
}
