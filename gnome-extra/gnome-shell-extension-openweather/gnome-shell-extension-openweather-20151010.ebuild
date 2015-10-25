# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit autotools-utils gnome2
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/jenslody/${PN}.git"
	SRC_URI=""
else
	inherit vcs-snapshot
	KEYWORDS="~amd64 ~x86"
	MY_PV="fe005139a46b7214f69c7a036d1b3b41cb368d42"
	SRC_URI="
		mirror://githubcl/jenslody/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
fi

DESCRIPTION="An extension for displaying weather informations in GNOME Shell"
HOMEPAGE="https://github.com/jenslody/gnome-shell-extension-openweather"

LICENSE="GPL-3+ BSD"
SLOT="0"
IUSE=""

RDEPEND="
	app-eselect/eselect-gnome-shell-extensions
"
DEPEND="
	${RDEPEND}
"
AUTOTOOLS_AUTORECONF=1

src_prepare() {
	autotools-utils_src_prepare
	gnome2_src_prepare
}

pkg_postinst() {
	gnome2_pkg_postinst

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
	gnome2_pkg_postrm
	ebegin "Updating list of installed extensions"
	eselect gnome-shell-extensions update
	eend $?
}
