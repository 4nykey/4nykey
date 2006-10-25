# Copyright 1999-2006 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit git mono autotools

DESCRIPTION="Mono bindings for the D-Bus messagebus."
HOMEPAGE="http://dbus.freedesktop.org"
EGIT_REPO_URI="git://anongit.freedesktop.org/git/dbus/dbus-mono"

LICENSE="GPL-2"
KEYWORDS="~x86"
SLOT="0"
IUSE=""

RDEPEND="
	>=sys-apps/dbus-0.90
	dev-lang/mono
"
DEPEND="
	${RDEPEND}
"

src_unpack() {
	git_src_unpack
	cd ${S}
	sed -i "s: example::" mono/Makefile.am
	eautoreconf
}

src_install() {
	einstall || die
	dodoc README
}
