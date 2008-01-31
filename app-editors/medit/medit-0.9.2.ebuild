# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit python fdo-mime gnome2-utils

DESCRIPTION="Multiplatform GTK text editor"
HOMEPAGE="http://mooedit.sourceforge.net"
SRC_URI="mirror://sourceforge/mooedit/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="python pcre xml debug fam doc"

RDEPEND="
	>=x11-libs/gtk+-2.6
	python? ( dev-python/pygtk )
	pcre? ( dev-libs/libpcre )
	xml? ( dev-libs/libxml2 )
	fam? ( virtual/fam )
"
DEPEND="
	${RDEPEND}
	dev-util/intltool
	doc? (
		dev-libs/libxslt
		=app-text/docbook-xml-dtd-4.4*
	)
"

src_compile() {
	econf \
		--htmldir="${ROOT}"/usr/share/doc/${PF}/html \
		--enable-libmoo \
		--enable-libmoo-headers \
		$(use_enable debug) \
		$(use_enable doc help) \
		$(use_with python) \
		$(use_with python mooterm) \
		$(use_enable python moo-module) \
		$(use_with pcre system-pcre) \
		$(use_with xml) \
		$(use_with fam) \
		|| die

	emake || die
}

src_install() {
	emake DESTDIR=${D} update_icon_cache=true update_mime=true install || die
	dodoc AUTHORS NEWS README THANKS TODO
}

pkg_postinst() {
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
	gnome2_icon_cache_update
	use python && python_mod_optimize "${ROOT}"usr/lib/moo/plugins
}

pkg_postrm() {
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
	gnome2_icon_cache_update
	use python && python_mod_cleanup "${ROOT}"usr/lib/moo/plugins
}
