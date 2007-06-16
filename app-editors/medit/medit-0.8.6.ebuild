# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="Multiplatform GTK text editor"
HOMEPAGE="http://mooedit.sourceforge.net"
SRC_URI="mirror://sourceforge/mooedit/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="python pcre xml debug fam"

RDEPEND="
	>=x11-libs/gtk+-2.6
	python? ( dev-python/pygtk )
	pcre? ( dev-libs/libpcre )
	xml? ( dev-libs/libxml2 )
	fam? ( virtual/fam )
"
DEPEND="
	${RDEPEND}
"

src_compile() {
	econf \
		--enable-libmoo \
		--enable-libmoo-headers \
		$(use_enable debug) \
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
	make DESTDIR=${D} install || die
	dodoc AUTHORS NEWS README THANKS TODO
}
