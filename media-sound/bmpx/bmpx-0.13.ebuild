# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/bmpx/bmpx-0.12_rc2.ebuild,v 1.1 2005/10/04 20:57:17 azarah Exp $

inherit subversion gnome2 autotools

DESCRIPTION="Next generation Beep Media Player"
HOMEPAGE="http://beep-media-player.org/index.php/BMPx_Homepage"
SRC_URI= #"mirror://sourceforge/beepmp/${PN}.tar.bz2"
ESVN_REPO_URI="http://svn.beep-media-player.org/bmpx/trunk"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="dbus mad ogg vorbis a52 flac theora perl python irssi xchat gtk
startup-notification gnome sysfs hal"

RDEPEND="gtk? ( >=x11-libs/gtk+-2.8.0
		virtual/fam )
	>=media-libs/taglib-1.4
	>=dev-libs/glib-2.8.0
	>=net-misc/neon-0.25.3
	>=gnome-base/libglade-2.5.1
	>=dev-libs/libxml2-2.6.1
	>=media-libs/musicbrainz-2.1.1
	gnome? ( >=gnome-base/gconf-2.6.4 )
	dbus? ( >=sys-apps/dbus-0.3.5 )
	hal? ( >=sys-apps/hal-0.5.6 )
	net-misc/curl
	startup-notification? ( >=x11-libs/startup-notification-0.8 )
	perl? ( dev-lang/perl )
	python? ( =dev-python/pygtk-2* )
	irssi? ( net-irc/irssi )
	xchat? ( || ( net-irc/xchat net-irc/xchat-gnome ) )
	>=media-libs/gstreamer-0.10.0
	>=media-libs/gst-plugins-base-0.10.0
	>=media-plugins/gst-plugins-pango-0.10.0
	mad? ( >=media-plugins/gst-plugins-mad-0.10.0 )
	ogg? ( >=media-plugins/gst-plugins-ogg-0.10.0 )
	vorbis? ( >=media-plugins/gst-plugins-ogg-0.10.0
		>=media-plugins/gst-plugins-vorbis-0.10.0 )
	a52? ( >=media-plugins/gst-plugins-a52dec-0.10.0 )
	flac? ( >=media-plugins/gst-plugins-flac-0.10.0 )
	theora? ( >=media-plugins/gst-plugins-ogg-0.10.0
	        >=media-plugins/gst-plugins-theora-0.10.0 )"

DEPEND="${RDEPEND}
	>=dev-util/intltool-0.29
	>=dev-util/pkgconfig-0.12.0
	dev-util/gtk-doc"

DOCS="AUTHORS ChangeLog NEWS README"

# gstreamer is default backend
G2CONF="--enable-amazon \
	$(use_enable dbus) \
	$(use_enable sysfs) \
	$(use_enable startup-notification sn) \
	$(use_enable gtk gui) \
	$(use_enable gnome gconf) \
	$(use_enable hal)"
use dbus && G2CONF="$(use_enable perl) $(use_enable python)"
use perl && G2CONF="$(use_enable irssi)"
use python || use perl && G2CONF="$(use_enable xchat)"

USE_DESTDIR="1"

src_unpack() {
	subversion_src_unpack
	# 'svn export' called by eclass won't copy 'external items' (libskinned, libhrel etc)
	cp -a \
		"${PORTAGE_ACTUAL_DISTDIR-${DISTDIR}}/svn-src/${PN/-svn/}/trunk"/* .
	# autotools fun begins
	cd libhrel
	gtkdocize --copy
	cd ${S}
	autopoint --force >& /dev/null
	eautoreconf || die
}
