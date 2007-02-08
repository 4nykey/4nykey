# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-im/gajim/gajim-0.9.1.ebuild,v 1.1 2005/12/27 17:46:46 svyatogor Exp $

inherit subversion autotools

DESCRIPTION="Jabber client written in PyGTK"
HOMEPAGE="http://www.gajim.org/"
ESVN_REPO_URI="svn://svn.gajim.org/gajim/trunk"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="dbus nls spell xscreensaver"

RDEPEND="
	>=dev-python/pygtk-2.6.0
	>=dev-python/pysqlite-2.0.4
	dbus? ( || ( <sys-apps/dbus-0.90 dev-libs/dbus-glib ) )
	spell? ( >=app-text/gtkspell-2.0.4 )
	xscreensaver? ( x11-libs/libXScrnSaver )
"
DEPEND="
	${RDEPEND}
	dev-util/intltool
	dev-util/pkgconfig
"

src_unpack() {
	subversion_src_unpack
	intltoolize --force --automake || die
	cd ${S}
	sed -i \
		-e '/set -x/d' \
		-e 's:\(intltoolize.*\)\\:\1:' \
		-ne '/aclocal/,$!p' \
		autogen.sh
	./autogen.sh
	AT_M4DIR="m4" eautoreconf
}

src_compile() {
	econf \
		$(use_enable nls) \
		$(use_enable dbus remote) \
		$(use_enable spell gtkspell) \
		$(use_enable xscreensaver idle) \
	|| die
	emake || die
}

src_install() {
	einstall || die
	rm -rf ${D}usr/share/doc
	dodoc README AUTHORS COPYING ChangeLog
	dohtml README.html
}
