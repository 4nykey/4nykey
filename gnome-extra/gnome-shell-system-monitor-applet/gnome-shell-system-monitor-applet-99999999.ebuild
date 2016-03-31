# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"
PLOCALES="zh_CN sl ru ro pt_BR pt pl it fr fa es_MX es_ES de cs"

inherit gnome2-utils l10n
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="git://github.com/paradoxxxzero/${PN}.git"
	SRC_URI=""
else
	inherit vcs-snapshot
	MY_PV="81d1c0800401033a563235f920655a936c907b06"
	SRC_URI="
		mirror://githubcl/paradoxxxzero/${PN}/tar.gz/${MY_PV}
		-> ${P}.tar.gz
	"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="An extension for displaying sensors information in GNOME Shell"
HOMEPAGE="https://github.com/paradoxxxzero/gnome-shell-system-monitor-applet"

LICENSE="GPL-3"
SLOT="0"
IUSE=""

DEPEND="
	app-eselect/eselect-gnome-shell-extensions
"
RDEPEND="
	${DEPEND}
	dev-python/pygtk
	gnome-base/libgtop[introspection]
	net-misc/networkmanager[introspection]
	!gnome-extra/gnome-shell-extensions-system-monitor
"

my_loc() {
	mv locale/${1}/LC_MESSAGES/system-monitor.mo ${1}.mo
	MOPREFIX="system-monitor" domo ${1}.mo
}

src_install() {
	cd system-monitor@paradoxxx.zero.gmail.com
	insinto /usr/share/gnome-shell/extensions/system-monitor@paradoxxx.zero.gmail.com
	doins *.*
	insinto /usr/share/glib-2.0/schemas
	doins schemas/*gschema.xml
	l10n_for_each_locale_do my_loc
	dodoc README*
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
