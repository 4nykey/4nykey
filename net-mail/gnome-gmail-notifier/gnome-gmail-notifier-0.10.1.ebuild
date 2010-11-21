# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit gnome2

DESCRIPTION="A Gmail Inbox Monitor for the GNOME2 desktop"
HOMEPAGE="http://code.google.com/p/gnome-gmail-notifier/"
SRC_URI="http://gnome-gmail-notifier.googlecode.com/files/${P}.tar.bz2"
RESTRICT="primaryuri"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	x11-libs/gtk+:2
	gnome-base/gconf
	x11-libs/libnotify
	net-libs/libsoup
	dev-libs/libxml2
	media-libs/gstreamer
	gnome-base/libgnome-keyring
"
DEPEND="
	${RDEPEND}
"

DOCS="AUTHORS ChangeLog NEWS README THANKS"
