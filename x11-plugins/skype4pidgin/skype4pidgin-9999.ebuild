# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit subversion

DESCRIPTION="Skype API Plugin for Pidgin"
HOMEPAGE="http://code.google.com/p/skype4pidgin"
ESVN_REPO_URI="http://skype4pidgin.googlecode.com/svn/trunk"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE="dbus nls"

DEPEND="
	net-im/pidgin[dbus?,nls?]
"
RDEPEND="
	${DEPEND}
	net-im/skype
"

src_compile() {
	local _tgt="libskype64.so libskypenet64.so "
	if use dbus; then
		_tgt+="libskype_dbus64.so"
		local _dfl="$(pkg-config dbus-1 --cflags) -DSKYPE_DBUS"
	fi
	if use nls; then
		CFLAGS+=" -DENABLE_NLS"
		emake locales
	fi
	emake \
		LINUX64_COMPILER="$(tc-getCC) ${CFLAGS} ${LDFLAGS}" \
		LIBPURPLE_CFLAGS="$(pkg-config purple --cflags) -DPURPLE_PLUGINS" \
		GLIB_CFLAGS="$(pkg-config glib-2.0 --cflags)" \
		DBUS_CFLAGS="${_dfl}" \
		${_tgt}
}

src_install() {
	insinto /usr/lib/purple-2
	doins *.so
	insinto /usr/share/pixmaps/pidgin/emotes/skype
	doins theme
	local d
	for d in 16 22 48; do
		insinto /usr/share/pixmaps/pidgin/protocols/${d}
		doins icons/${d}/*.png
	done
	use nls && domo po/*.mo
	dodoc {CHANGELOG,README,TODO}.txt
}
