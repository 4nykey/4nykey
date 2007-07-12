# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-im/tkabber/tkabber-0.9.9.ebuild,v 1.6 2007/05/18 22:10:55 welp Exp $

inherit eutils

DESCRIPTION="Tkabber is a Free and Open Source client for the Jabber instant messaging system, written in Tcl/Tk."
HOMEPAGE="http://tkabber.jabber.ru/"
SRC_URI="http://files.jabber.ru/${PN}/${P}.tar.gz
	plugins? ( http://files.jabber.ru/${PN}/${PN}-plugins-${PV}.tar.gz )"
IUSE="crypt plugins ssl examples"

DEPEND="
	>=dev-lang/tcl-8.3.3
	>=dev-lang/tk-8.3.3
	|| ( >=dev-tcltk/tclxml-3.0 dev-tcltk/tclxml-expat )
	crypt? ( >=dev-tcltk/tclgpgme-1.0 )
	>=dev-tcltk/tcllib-1.3
	>=dev-tcltk/bwidget-1.3
	ssl? ( >=dev-tcltk/tls-1.4.1 )
	>=dev-tcltk/tkXwin-1.0
	|| ( dev-tcltk/tktray >=dev-tcltk/tkTheme-1.0 )
"

LICENSE="GPL-2"
KEYWORDS="alpha amd64 sparc x86"
SLOT="0"

pkg_setup() {
	if has_version '>=dev-tcltk/tclxml-3.0' \
		&& ! built_with_use dev-tcltk/tclxml expat ; then
		eerror "tclxml is missing expat support."
		eerror "Please add 'expat' to your USE flags, and re-emerge tclxml."
		die "tclxml needs expat support"
	fi
}

src_compile() {
	return 0
}

src_install() {
	use examples && _xtra="install-examples"
	emake PREFIX=/usr DESTDIR=${D} install-bin ${_xtra} || die
	dosed \
		's:exec:TKABBER_SITE_PLUGINS=/usr/share/tkabber-plugins exec:' \
		/usr/bin/tkabber
	dodoc AUTHORS ChangeLog README
	dohtml doc/tkabber.html
	if use plugins; then
		cd ${WORKDIR}/${PN}-plugins-${PV}
		emake PREFIX=/usr DESTDIR=${D} install-bin || die
		for x in ChangeLog README; do
			newdoc ${x} plugins-${x}
		done
	fi
}
