# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-client/galeon/galeon-2.0.4.ebuild,v 1.8 2008/03/14 17:27:42 armin76 Exp $

EAPI="2"

inherit gnome2 git

DESCRIPTION="A GNOME Web browser based on gecko (mozilla's rendering engine)"
HOMEPAGE="http://galeon.sourceforge.net"
SRC_URI=""
EGIT_REPO_URI="git://git.gnome.org/galeon"
EGIT_PATCHES=("${FILESDIR}"/${P}*.diff)

LICENSE="GPL-2"
KEYWORDS="~x86 ~amd64"
SLOT="0"
IUSE=""

RDEPEND="
	>=net-libs/xulrunner-1.9.2
	>=x11-libs/gtk+-2.4.0
	>=dev-libs/libxml2-2.6.6
	>=gnome-base/libgnomeui-2.5.2
	>=gnome-base/gnome-vfs-2
	>=gnome-base/gnome-desktop-2.10.0
	>=gnome-base/libglade-2.3.1
"
DEPEND="
	${RDEPEND}
	app-text/rarian
	dev-util/pkgconfig
	>=dev-util/intltool-0.30
	>=sys-devel/gettext-0.11
"

DOCS="AUTHORS ChangeLog FAQ README README.ExtraPrefs THANKS TODO NEWS"

G2CONF="
	--with-mozilla=libxul-embedding
"

src_prepare() {
	sed -i configure.in -e 's:libxul-embedding-unstable:libxul-embedding:'
	git_src_prepare
	ebegin "Running ./autogen.sh"
		NOCONFIGURE=y ./autogen.sh >${T}/autogen.log 2>&1
	eend $? "autogen.sh failed. See ${T}/autogen.log for details."
}
