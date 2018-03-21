# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PLOCALES="de es fr hu pl"
inherit l10n gnome2-utils
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/franglais125/${PN}"
else
	inherit vcs-snapshot
	MY_PV="8fe9355"
	[[ -n ${PV%%*_p*} ]] && MY_PV="v${PV}"
	SRC_URI="
		mirror://githubcl/franglais125/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="An extension for GNOME Shell to hide the title bar of maximized windows"
HOMEPAGE="https://extensions.gnome.org/extension/1267/no-title-bar"

LICENSE="GPL-2"
SLOT="0"
IUSE="nls"

DEPEND="
	app-eselect/eselect-gnome-shell-extensions
"
RDEPEND="
	${DEPEND}
	gnome-base/gnome-shell
	x11-apps/xprop
"
DEPEND="
	${DEPEND}
	nls? (
		sys-devel/gettext
		dev-util/intltool
	)
"

src_prepare() {
	default
	use nls && local _l="$(l10n_get_locales)"
	sed \
		-e "/MSGSRC = / s:= .*:= ${_l}:" \
		-e '/extension: / s:\./schemas/gschemas\.compiled::' \
		-e '/MSGSRC:/ s:\.po=\.mo:%=po/%.mo:' \
		-e 's:_build/schemas:$(DESTDIR)/usr/share/glib-2.0/schemas:' \
		-e '/cp schemas\/gschemas\.compiled/d' \
		-i Makefile
}

pkg_preinst() {
	gnome2_schemas_savelist
}

pkg_postinst() {
	gnome2_schemas_update
	ebegin "Updating list of installed extensions"
	eselect gnome-shell-extensions update
	eend $?
}

pkg_postrm() {
	gnome2_schemas_update
	ebegin "Updating list of installed extensions"
	eselect gnome-shell-extensions update
	eend $?
}
