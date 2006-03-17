# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-im/gajim/gajim-0.9.1.ebuild,v 1.1 2005/12/27 17:46:46 svyatogor Exp $

inherit virtualx multilib subversion

DESCRIPTION="Jabber client written in PyGTK"
HOMEPAGE="http://www.gajim.org/"
ESVN_REPO_URI="svn://svn.gajim.org/gajim/trunk"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="dbus nls spell srv"

#Removed amd64 from keywords until gcc4 is moved to unstable (#1092984)
#amd64? ( >=sys-devel/gcc-4 )
DEPEND=">=dev-python/pygtk-2.4.0
	>=dev-lang/python-2.3.0
	>=x11-libs/gtk+-2.4
	>=dev-python/pysqlite-2.0.4
	dbus? ( >=sys-apps/dbus-0.23 )
	spell? ( >=app-text/gtkspell-2.0.4 )
	srv? ( dev-python/dnspython )"

pkg_setup() {
	if use dbus && ! built_with_use sys-apps/dbus python; then
		eerror "Please rebuild dbus with USE=\"python\"."
		die "Python D-bus support missing."
	fi
	#Until #103056 is resolved completely.
	if ! built_with_use "<dev-python/pygtk-2.8.0-r2" gnome; then
		eerror "Gajim requires Glade Python modules."
		eerror "Please rebuild pygtk with USE=\"gnome\","
		eerror "or emerge \">=pygtk-2.8.0-r2\"."
		die "Python Glade modules missing."
	fi
}

src_compile() {
	targets="idle trayicon gajim.desktop"
	use nls && targets="${targets} translation"
	use spell && targets="${targets} gtkspell"
	Xemake ${targets} || die "Xemake failed"
}

src_install() {
	Xemake PREFIX=/usr DESTDIR=${D} LIBDIR=/$(get_libdir) install || die
	dodoc README AUTHORS COPYING Changelog
}

pkg_postinst() {
	if use x86; then
		einfo "If you want to make Gajim run faster,"
		einfo "emerge dev-python/psyco, an extension"
		einfo "module which can speed up the executuion"
		einfo "of Python code."
	fi
}
