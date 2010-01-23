# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-client/galeon/galeon-2.0.4.ebuild,v 1.8 2008/03/14 17:27:42 armin76 Exp $

EAPI="2"

inherit gnome2 autotools git

DESCRIPTION="A GNOME Web browser based on gecko (mozilla's rendering engine)"
HOMEPAGE="http://galeon.sourceforge.net"
SRC_URI="
	mirror://gentoo/${PN}-2.0.7-patches.tar.lzma
"
EGIT_REPO_URI="git://git.gnome.org/galeon"
EGIT_PATCHES=("${FILESDIR}"/${P}*.diff)
EGIT_BOOTSTRAP="intltoolize && eautoreconf"

LICENSE="GPL-2"
KEYWORDS="~x86 ~amd64"
SLOT="0"
IUSE="nautilus"

RDEPEND="
	>=net-libs/xulrunner-1.9.2
	nautilus? ( gnome-base/nautilus )
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

pkg_setup() {
	G2CONF="
		--with-mozilla=libxul-embedding
		$(use_enable nautilus nautilus-view)
	"
}

src_unpack() {
	unpack ${A}
	git_src_unpack
}

src_prepare() {
	EGIT_PATCHES+=("${WORKDIR}"/${PN}*patches/${PN}*{dfltfont,warnings}.patch)
	sed -i configure.in -e 's:libxul-embedding-unstable:libxul-embedding:'
	git_src_prepare
}
