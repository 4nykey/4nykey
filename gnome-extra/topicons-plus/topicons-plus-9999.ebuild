# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit gnome2-utils
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/phocean/${PN}"
else
	inherit vcs-snapshot
	KEYWORDS="~amd64 ~x86"
	MY_PV="c2788be"
	[[ -n ${PV%%*_p*} ]] && MY_PV="v${PV}"
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

DEPEND="
	app-eselect/eselect-gnome-shell-extensions
"
RDEPEND="
	${DEPEND}
	gnome-base/gnome-shell
"

src_compile() { :; }

src_install() {
	local _u=$(awk -F'"' '/uuid/ {print $4}' metadata.json)
	insinto /usr/share/gnome-shell/extensions/${_u}
	doins *.js*
	insinto /usr/share/glib-2.0/schemas
	doins schemas/*.xml
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
