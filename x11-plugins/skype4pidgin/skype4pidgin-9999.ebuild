# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PLOCALES="cs de en_AU es fr hu it ja mk nb pl pt_BR pt ru"
inherit l10n toolchain-funcs
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/EionRobb/skype4pidgin.git"
else
	SRC_URI="
		mirror://githubcl/EionRobb/${PN}/tar.gz/${PV} -> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="Skype API Plugin for Pidgin"
HOMEPAGE="http://eion.robbmob.com"

LICENSE="GPL-3"
SLOT="0"
IUSE="dbus nls"

DEPEND="
	net-im/pidgin[dbus?,nls?]
"
RDEPEND="
	${DEPEND}
"
HDEPEND="
	${DEPEND}
	net-im/skype
"
BDEPEND="
	${DEPEND}
	virtual/pkgconfig
	nls? ( sys-devel/gettext )
"

src_prepare() {
	rmloc() {
		rm -f "${S}"/po/${1}.po
	}
	use nls && l10n_for_each_disabled_locale_do rmloc
	default
	sed \
		-e 's:-march=[^ ]\+::' \
		-e 's:-O[0-9]\+ ::' \
		-i Makefile
}

src_compile() {
	local _tgt="libskype.so libskypenet.so " _pc="$(tc-getPKG_CONFIG)"
	if use dbus; then
		_tgt+="libskype_dbus.so"
		local _dfl="$(${_pc} dbus-1 --cflags) -DSKYPE_DBUS"
	fi
	if use nls; then
		CFLAGS+=" -DENABLE_NLS"
		emake locales
	fi
	emake \
		LINUX32_COMPILER="$(tc-getCC) ${CFLAGS} ${LDFLAGS}" \
		LINUX64_COMPILER="$(tc-getCC) ${CFLAGS} ${LDFLAGS}" \
		LIBPURPLE_CFLAGS="$(${_pc} purple --cflags) -DPURPLE_PLUGINS" \
		GLIB_CFLAGS="$(${_pc} glib-2.0 --cflags)" \
		DBUS_CFLAGS="${_dfl}" \
		${_tgt}
}

src_install() {
	insinto "$($(tc-getPKG_CONFIG) purple --variable=plugindir)"
	doins *.so
	insinto /usr/share/pixmaps/pidgin/emotes/skype
	doins theme
	local d
	for d in 16 22 48; do
		insinto /usr/share/pixmaps/pidgin/protocols/${d}
		doins icons/${d}/*.png
	done
	use nls && domo po/*.mo
	einstalldocs
}
