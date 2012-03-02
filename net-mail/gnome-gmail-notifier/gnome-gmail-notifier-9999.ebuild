# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit gnome2 subversion autotools-utils

DESCRIPTION="A Gmail Inbox Monitor for the GNOME2 desktop"
HOMEPAGE="http://notifier.geekysuavo.org"
ESVN_REPO_URI="http://gnome-gmail-notifier.googlecode.com/svn/trunk"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="dbus networkmanager nls"

AUTOTOOLS_AUTORECONF="1"
PATCHES=("${FILESDIR}"/${PN}*.diff)

RDEPEND="
	x11-libs/gtk+:2
	gnome-base/gconf
	x11-libs/libnotify
	net-libs/libsoup
	dev-libs/libxml2
	media-libs/gstreamer
	gnome-base/libgnome-keyring
	dbus? ( dev-libs/dbus-glib )
	networkmanager? ( net-misc/networkmanager )
"
DEPEND="
	${RDEPEND}
"

src_prepare() {
	autotools-utils_src_prepare
	gnome2_src_prepare
}

src_configure() {
	local myeconfargs=(
		$(use_enable dbus)
		$(use_enable networkmanager nm)
		$(use_enable nls)
	)
	autotools-utils_src_configure
}
