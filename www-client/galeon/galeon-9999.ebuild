# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-client/galeon/galeon-2.0.4.ebuild,v 1.8 2008/03/14 17:27:42 armin76 Exp $

inherit gnome2 autotools git

DESCRIPTION="A GNOME Web browser based on gecko (mozilla's rendering engine)"
HOMEPAGE="http://galeon.sourceforge.net"
SRC_URI=""
EGIT_REPO_URI="git://git.gnome.org/galeon"
EGIT_PATCHES=("${FILESDIR}"/${PN}*.diff)
EGIT_BOOTSTRAP="intltoolize && eautoreconf"

LICENSE="GPL-2"
KEYWORDS="~x86 ~amd64"
SLOT="0"
IUSE="seamonkey xulrunner nautilus"

RDEPEND="
	xulrunner? ( net-libs/xulrunner )
	!xulrunner? (
		seamonkey? ( =www-client/seamonkey-1* )
		!seamonkey? ( =www-client/mozilla-firefox-2* )
	)
	nautilus? ( gnome-base/nautilus )
	>=dev-libs/glib-2
	>=x11-libs/gtk+-2.4.0
	>=dev-libs/libxml2-2.6.6
	>=gnome-base/gconf-2.3.2
	>=gnome-base/orbit-2
	>=gnome-base/libbonobo-2
	>=gnome-base/libbonoboui-2.1.1
	>=gnome-base/libgnomeui-2.5.2
	>=gnome-base/gnome-vfs-2
	>=gnome-base/gnome-desktop-2.10.0
	>=gnome-base/libglade-2.3.1
	app-text/scrollkeeper
"
DEPEND="
	${RDEPEND}
	dev-util/pkgconfig
	>=dev-util/intltool-0.30
	>=sys-devel/gettext-0.11
"

DOCS="AUTHORS ChangeLog FAQ README README.ExtraPrefs THANKS TODO NEWS"

pkg_setup() {
	if use xulrunner; then
		if has_version '>=net-libs/xulrunner-1.9'; then
			G2CONF="--with-mozilla=libxul-embedding-unstable"
			if has_version '>=net-libs/xulrunner-1.9.1'; then
				EGIT_PATCHES+=("${FILESDIR}"/${PN}-2.0.7-build-with-xulrunner-1.9.1.patch)
			fi
		else
			G2CONF="--with-mozilla=xulrunner"
		fi
	elif use seamonkey; then
		G2CONF="--with-mozilla=seamonkey"
	else
		G2CONF="--with-mozilla=firefox"
	fi

	G2CONF+=" $(use_enable nautilus nautilus-view)"
}
