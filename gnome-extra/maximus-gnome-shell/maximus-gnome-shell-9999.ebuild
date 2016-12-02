# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit gnome2-utils
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/luispabon/${PN}"
else
	inherit vcs-snapshot
	MY_PV="cb79a62"
	SRC_URI="
		mirror://githubcl/luispabon/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="An extension to undecorate maximized windows"
HOMEPAGE="https://github.com/luispabon/${PN}"

LICENSE="MIT"
SLOT="0"
IUSE=""

BDEPEND="
	app-eselect/eselect-gnome-shell-extensions
"
HDEPEND="
	${BDEPEND}
	x11-apps/xprop
"

src_compile() { :; }

src_install() {
	local _u=$(awk -F'"' '/uuid/ {print $4}' "${S}"/src/metadata.json)
	insinto /usr/share/gnome-shell/extensions/"${_u}"
	doins src/*.js*
	insinto /usr/share/glib-2.0/schemas
	doins src/schemas/org.gnome.shell.extensions.${PN%%-*}.gschema.xml
	einstalldocs
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
