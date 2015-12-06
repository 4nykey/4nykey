# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/deadalnix/${PN}"
	SRC_URI=""
else
	inherit vcs-snapshot
	KEYWORDS="~amd64 ~x86"
	SRC_URI="
		mirror://githubcl/deadalnix/${PN}/tar.gz/${PV} -> ${P}.tar.gz
	"
fi

DESCRIPTION="An Gnome Shell extension that merges the activity bar and the title bar of maximized window"
HOMEPAGE="https://github.com/deadalnix/pixel-saver"

LICENSE="GPL-3"
SLOT="0"
IUSE=""

DEPEND="
	app-eselect/eselect-gnome-shell-extensions
"
RDEPEND="
	${DEPEND}
	x11-apps/xprop
"

src_install() {
	insinto /usr/share/gnome-shell/extensions
	doins -r pixel-saver@deadalnix.me
	dodoc README*
}

pkg_postinst() {
	ebegin "Updating list of installed extensions"
	eselect gnome-shell-extensions update
	eend $?
	elog
	elog "Installed extensions installed are initially disabled by default."
	elog "To change the system default and enable some extensions, you can use"
	elog "# eselect gnome-shell-extensions"
	elog "Alternatively, to enable/disable extensions on a per-user basis,"
	elog "you can use the https://extensions.gnome.org/ web interface, the"
	elog "gnome-extra/gnome-tweak-tool GUI, or modify the org.gnome.shell"
	elog "enabled-extensions gsettings key from the command line or a script."
	elog
}

pkg_postrm() {
	ebegin "Updating list of installed extensions"
	eselect gnome-shell-extensions update
	eend $?
}
