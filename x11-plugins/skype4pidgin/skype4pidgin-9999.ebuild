# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

PLOCALES="cs de en_AU es fr hu it ja mk nb pl pt_BR pt ru"
inherit l10n git-r3

DESCRIPTION="Skype API Plugin for Pidgin"
HOMEPAGE="http://eion.robbmob.com"
EGIT_REPO_URI="https://github.com/EionRobb/skype4pidgin.git"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="dbus nls"

DEPEND="
	net-im/pidgin[dbus?,nls?]
"
RDEPEND="
	${DEPEND}
	net-im/skype
"
DEPEND="
	${DEPEND}
	dev-util/pkgconfig
	nls? ( sys-devel/gettext )
"

rmloc() {
	rm -f "${S}"/po/${1}.po
}

src_prepare() {
	use nls && l10n_for_each_disabled_locale_do rmloc
}

src_compile() {
	local _arc="$(usex amd64 '64' '')"
	local _tgt="libskype${_arc}.so libskypenet${_arc}.so "
	if use dbus; then
		_tgt+="libskype_dbus${_arc}.so"
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
	insinto "$(pkg-config purple --variable=plugindir)"
	doins *.so
	insinto /usr/share/pixmaps/pidgin/emotes/skype
	doins theme
	local d
	for d in 16 22 48; do
		insinto /usr/share/pixmaps/pidgin/protocols/${d}
		doins icons/${d}/*.png
	done
	use nls && domo po/*.mo
	dodoc {CHANGELOG,README,TODO}.*
}
