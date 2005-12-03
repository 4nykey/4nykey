# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="A library for user notifications"
HOMEPAGE="http://www.galago-project.org/"
SRC_URI="http://www.galago-project.org/files/releases/source/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="gtk2"

RDEPEND="dev-libs/popt
		>=glib-2.2.2
		gtk2? ( =x11-libs/gtk+-2* )
		>=dbus-0.23"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

src_install() {
	einstall || die "einstall failed"
}

