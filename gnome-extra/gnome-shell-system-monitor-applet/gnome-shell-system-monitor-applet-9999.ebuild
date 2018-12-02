# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PLOCALES="ar ca cs de es_ES es_MX fa fr it pl pt pt_BR ro ru sk zh_CN"

inherit gnome2-utils l10n
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/paradoxxxzero/${PN}.git"
	SRC_URI=""
else
	inherit vcs-snapshot
	MY_PV="0c5dc8e"
	[[ -n ${PV%%*_p*} ]] && MY_PV="v${PV}"
	SRC_URI="
		mirror://githubcl/paradoxxxzero/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="An extension for displaying sensors information in GNOME Shell"
HOMEPAGE="https://github.com/paradoxxxzero/gnome-shell-system-monitor-applet"

LICENSE="GPL-3"
SLOT="0"
IUSE="nls"

DEPEND="
	app-eselect/eselect-gnome-shell-extensions
"
RDEPEND="
	${DEPEND}
	gnome-base/gnome-shell
	dev-python/pygtk
	gnome-base/libgtop[introspection]
	net-misc/networkmanager[introspection]
"
DEPEND="
	${DEPEND}
	nls? ( sys-devel/gettext )
"

src_compile() {
	use nls || return
	my_loc() {
		msgfmt po/${1}/system-monitor.po -o ${1}.mo
	}
	l10n_for_each_locale_do my_loc
}

src_install() {
	local _d="$(awk '/UUID =/ {print $3}' Makefile)"
	insinto /usr/share/gnome-shell/extensions/${_d}
	doins ${_d}/*.{js,json,css}
	insinto /usr/share/glib-2.0/schemas
	doins ${_d}/schemas/*gschema.xml
	einstalldocs
	use nls && MOPREFIX="${_d%@*}" domo *.mo
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
