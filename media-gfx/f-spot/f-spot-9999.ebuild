# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/f-spot/f-spot-0.8.2.ebuild,v 1.10 2013/10/12 12:11:28 pacho Exp $

EAPI="5"

inherit autotools-utils gnome2 mono multilib git-2

DESCRIPTION="Personal photo management application for the gnome desktop"
HOMEPAGE="http://f-spot.org"
SRC_URI=""
EGIT_REPO_URI="git://git.gnome.org/f-spot"
EGIT_HAS_SUBMODULES="y"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc gnome-screensaver flickr raw"

RDEPEND="
	gnome-base/gnome-desktop:2
	dev-dotnet/gtk-sharp-beans
	media-libs/lcms:0
	>=dev-lang/mono-2.2
	dev-dotnet/gnome-keyring-sharp
	>=dev-dotnet/gtk-sharp-2.12.2:2
	dev-dotnet/dbus-sharp-glib
	dev-dotnet/taglib-sharp
	>=dev-dotnet/gnome-sharp-2.8:2
	dev-dotnet/gconf-sharp:2
	>=media-libs/lcms-1.12:0
	>=x11-libs/cairo-1.4
	doc? ( >=app-text/gnome-doc-utils-0.17.3 )
	flickr? ( >=dev-dotnet/flickrnet-bin-2.2-r1 )
	raw?	( media-gfx/dcraw )
	gnome-screensaver? ( gnome-extra/gnome-screensaver )
"

DEPEND="
	${RDEPEND}
	>=dev-dotnet/gtk-sharp-gapi-2.12.2
	>=app-text/gnome-doc-utils-0.17.3
	virtual/pkgconfig
	>=dev-util/intltool-0.35
"

DOCS="AUTHORS ChangeLog MAINTAINERS NEWS README"
G2CONF="
	${G2CONF}
	--disable-static
	--disable-scrollkeeper
	$(use_enable doc user-help)
"
PATCHES=( "${FILESDIR}"/${PN}-*.diff )
AT_M4DIR="build/m4/f-spot build/m4/shamrock build/m4"
AUTOTOOLS_AUTORECONF="1"

src_prepare() {
	sed  -r -i -e 's:-D[A-Z]+_DISABLE_DEPRECATED::g' \
		lib/libfspot/Makefile.am || die

	if ! use flickr; then
		sed -i -e '/FSpot.Exporters.Flickr/d' src/Extensions/Exporters/Makefile.am || die
		sed -i -e '/FSPOT_CHECK_FLICKRNET/d' configure.ac || die
	fi

	autotools-utils_src_prepare
	gnome2_src_prepare
}
