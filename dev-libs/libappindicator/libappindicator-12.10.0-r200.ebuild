# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libappindicator/libappindicator-12.10.0.ebuild,v 1.3 2013/05/12 14:40:30 pacho Exp $

EAPI=5
VALA_MIN_API_VERSION="0.16"
VALA_USE_DEPEND="vapigen"

inherit eutils vala

DESCRIPTION="A library to allow applications to export a menu into the Unity Menu bar"
HOMEPAGE="http://launchpad.net/libappindicator"
DBUSMENU="libdbusmenu-12.10.2"
SRC_URI="
	http://launchpad.net/${PN}/${PV%.*}/${PV}/+download/${P}.tar.gz
	http://launchpad.net/dbusmenu/${PV%.*}/${DBUSMENU#*-}/+download/${DBUSMENU}.tar.gz
"
RESTRICT="primaryuri"

LICENSE="LGPL-2.1 LGPL-3"
SLOT="2"
KEYWORDS="~amd64 ~x86"
IUSE="+introspection"

RDEPEND="
	>=dev-libs/dbus-glib-0.98
	>=dev-libs/glib-2.26
	>=dev-libs/libindicator-12.10.0:0
	x11-libs/gtk+:2
	introspection? ( >=dev-libs/gobject-introspection-1 )
"
DEPEND="
	${RDEPEND}
	virtual/pkgconfig
	introspection? ( $(vala_depend) )
"

src_prepare() {
	# Disable MONO for now because of http://bugs.gentoo.org/382491
	sed -i -e '/^MONO_REQUIRED_VERSION/s:=.*:=9999:' configure || die
	sed -i -e 's:dbusmenu-gtk-0.4 >= [\\]*\$DBUSMENUGTK_REQUIRED_VERSION::' configure || die
	sed -i -e 's:dbusmenu-glib-0.4 ::' src/appindicator-0.1.pc.in || die
	sed -i src/Makefile.in -e \
		"s:LIBRARY_LIBS = .*:& \
			${WORKDIR}/${DBUSMENU}/libdbusmenu-glib/libdbusmenu-glib.la\
			${WORKDIR}/${DBUSMENU}/libdbusmenu-gtk/libdbusmenu-gtk.la:"
	sed -i bindings/Makefile.in -e 's:\(@USE_GTK3_FALSE@SUBDIRS =\) python:\1:' 
	use introspection && vala_src_prepare
}

src_configure() {
	pushd "${WORKDIR}"/${DBUSMENU} >& /dev/null
	HAVE_VALGRIND_FALSE='true' \
	econf \
		--disable-silent-rules \
		--disable-tests \
		--enable-static \
		--disable-shared \
		--with-pic \
		--with-gtk=2
	popd
	CPPFLAGS="-I${WORKDIR}/${DBUSMENU}" \
	econf \
		--disable-silent-rules \
		--disable-static \
		--with-html-dir=/usr/share/doc/${PF}/html \
		--with-gtk=2
}

src_compile() {
	emake -C "${WORKDIR}"/${DBUSMENU}/libdbusmenu-glib
	emake -C "${WORKDIR}"/${DBUSMENU}/libdbusmenu-gtk
	emake
}

src_install() {
	default
	prune_libtool_files
}
