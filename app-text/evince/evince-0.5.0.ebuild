# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/evince/evince-0.4.0-r2.ebuild,v 1.6 2005/10/21 10:02:22 leonardop Exp $

inherit eutils gnome2

DESCRIPTION="Simple document viewer for GNOME"
HOMEPAGE="http://www.gnome.org/projects/evince/"
LICENSE="GPL-2"

# TODO: Use 'gnome' flag instead of 'nautilus'
IUSE="dbus doc dvi nautilus t1lib tiff djvu"
# For use.local.desc:
# app-text/evince:t1lib - Enable Type1 fonts support in .dvi files

SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"

RDEPEND="
	dvi? ( app-text/tetex )
	dvi? ( t1lib? ( >=media-libs/t1lib-5.0.0 ) )
	dbus? ( >=sys-apps/dbus-0.33 )
	tiff? ( >=media-libs/tiff-3.6 )
	djvu? ( >=app-text/djvu-3.5.15 )
	>=app-text/poppler-0.5.0
	>=dev-libs/glib-2
	>=gnome-base/gnome-vfs-2.0
	>=gnome-base/libglade-2
	>=gnome-base/gconf-2
	gnome-base/libgnome
	>=gnome-base/libgnomeprintui-2.6
	>=gnome-base/libgnomeui-2.6
	nautilus? ( >=gnome-base/nautilus-2.10 )
	>=x11-libs/gtk+-2.8
	virtual/x11
	"

DEPEND="${RDEPEND}
	app-text/scrollkeeper
	>=app-text/gnome-doc-utils-0.3.2
	>=dev-util/pkgconfig-0.9
	>=dev-util/intltool-0.28"

PROVIDE="virtual/pdfviewer
	virtual/psviewer"

DOCS="AUTHORS ChangeLog NEWS README TODO"
USE_DESTDIR="1"
ELTCONF="--portage"


pkg_setup() {
	G2CONF="--disable-scrollkeeper \
		--enable-comics     \
		$(use_enable dvi)   \
		$(use_enable t1lib) \
		$(use_enable dbus)  \
		$(use_enable tiff)  \
		$(use_enable djvu)  \
		$(use_enable nautilus)"

	if ! built_with_use app-text/poppler gtk; then
		einfo "Please re-emerge app-text/poppler with the gtk USE flag set"
		die "poppler needs gtk flag set"
	fi
}

src_unpack(){
	unpack "${A}"
	cd "${S}"

	# Fix .desktop file so menu item shows up
	epatch ${FILESDIR}/${PN}-0.4.0-display-menu.patch
}
