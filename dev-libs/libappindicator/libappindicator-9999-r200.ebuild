# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libappindicator/libappindicator-12.10.0.ebuild,v 1.3 2013/05/12 14:40:30 pacho Exp $

EAPI=5
VALA_MIN_API_VERSION="0.16"
VALA_USE_DEPEND="vapigen"
PYTHON_COMPAT=(python2_7)

inherit autotools-utils python-single-r1 vala bzr

DESCRIPTION="A library to allow applications to export a menu into the Unity Menu bar"
HOMEPAGE="http://launchpad.net/libappindicator"
EBZR_REPO_URI="lp:${PN}"

LICENSE="LGPL-2.1 LGPL-3"
SLOT="2"
KEYWORDS="~amd64 ~x86"
IUSE="doc +introspection python static-libs"

RDEPEND="
	>=dev-libs/dbus-glib-0.98
	>=dev-libs/glib-2.26
	>=dev-libs/libindicator-12.10.0:0
	x11-libs/gtk+:2
	introspection? ( >=dev-libs/gobject-introspection-1 )
	python? ( ${PYTHON_DEPS} )
"
DEPEND="
	${RDEPEND}
	virtual/pkgconfig
	introspection? ( $(vala_depend) )
"
AUTOTOOLS_IN_SOURCE_BUILD="1"
AUTOTOOLS_PRUNE_LIBTOOL_FILES="modules"

src_unpack() {
	DBUSMENU="${S}/src/libdbusmenu"
	bzr_fetch
	EBZR_REPO_URI="lp:libdbusmenu" EBZR_PROJECT="libdbusmenu" \
	EBZR_UNPACK_DIR="${DBUSMENU}" bzr_fetch
}

src_prepare() {
	# Disable MONO for now because of http://bugs.gentoo.org/382491
	sed \
		-e '/^MONO_REQUIRED_VERSION/s:=.*:=9999:' \
		-e 's:dbusmenu-gtk-0.4 >= [\\]*\$DBUSMENUGTK_REQUIRED_VERSION::' \
		-i configure.ac || die
	sed \
		-e "s:\$(LIBRARY_LIBS):& \
			${DBUSMENU}/libdbusmenu-glib/libdbusmenu-glib.la\
			${DBUSMENU}/libdbusmenu-gtk/libdbusmenu-gtk.la:"\
		-e 's:-Werror::' \
		-i src/Makefile.am || die
	sed -e 's:dbusmenu-glib-0.4 ::' -i src/appindicator-0.1.pc.in || die
	if use !python; then
		sed -e '/python/d' -i bindings/Makefile.am || die
	fi

	sed \
		-e '/indicator_desktop_shortcuts_nick_exec_with_context/d' \
		-i src/app-indicator.c
	
	use introspection && vala_src_prepare
	eautoreconf
	cd ${DBUSMENU}
	eautoreconf
}

src_configure() {
	local myeconfargs=(
		--disable-silent-rules
		--disable-tests
		--with-gtk=${SLOT}
		$(use_enable doc gtk-doc)
		$(use_enable doc gtk-doc-html)
	)

	CPPFLAGS="-I${DBUSMENU}" econf \
		"${myeconfargs[@]}" \
		$(use_enable static-libs static)

	cd ${DBUSMENU}
	HAVE_VALGRIND_FALSE='true' econf \
		"${myeconfargs[@]}" \
		--enable-static \
		--disable-shared \
		--with-pic
}

src_compile() {
	emake -C ${DBUSMENU}/libdbusmenu-glib
	emake -C ${DBUSMENU}/libdbusmenu-gtk
	default
}
