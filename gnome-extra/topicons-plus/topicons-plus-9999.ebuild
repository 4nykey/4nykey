# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit gnome2-utils
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/phocean/${PN}"
	SRC_URI=""
else
	inherit vcs-snapshot
	KEYWORDS="~amd64 ~x86"
	MY_PV="c2788be"
	SRC_URI="
		mirror://githubcl/phocean/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
fi

DESCRIPTION="An extension to move legacy tray icons to the top panel"
HOMEPAGE="https://github.com/phocean/${PN}"

LICENSE="GPL-2+"
SLOT="0"
IUSE=""

BDEPEND="
	app-eselect/eselect-gnome-shell-extensions
"
HDEPEND="
	${BDEPEND}
"

src_compile() { :; }

src_install() {
	insinto /usr/share/gnome-shell/extensions/TopIcons@phocean.net
	doins *.js*
	insinto /usr/share/glib-2.0/schemas
	doins schemas/*.xml
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
