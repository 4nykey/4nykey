# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit gnome2-utils
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/zpydr/${PN}"
	SRC_URI=""
else
	inherit vcs-snapshot
	KEYWORDS="~amd64 ~x86"
	SRC_URI="
		mirror://githubcl/zpydr/${PN}/tar.gz/${PV} -> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
fi

DESCRIPTION="TaskBar displays icons of running applications on the top or bottom panel"
HOMEPAGE="https://github.com/zpydr/gnome-shell-extension-taskbar"

LICENSE="GPL-3"
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
	insinto /usr/share/gnome-shell/extensions/TaskBar@zpydr
	doins -r images *.{css,js,json}
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
