# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"
GCONF_DEBUG="no"
GNOME2_LA_PUNT="yes"

inherit gnome2 git-2 autotools-utils #versionator

DESCRIPTION="An extension for displaying weather notifications in GNOME Shell"
HOMEPAGE="https://github.com/Neroth/gnome-shell-extension-weather"
SRC_URI=""

EGIT_REPO_URI="git://github.com/Neroth/gnome-shell-extension-weather.git"
#EGIT_BRANCH="gnome$(get_version_component_range -2)"
EGIT_BRANCH="master"
EGIT_COMMIT="${EGIT_BRANCH}"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

AUTOTOOLS_AUTORECONF="1"

DEPEND="
	app-admin/eselect-gnome-shell-extensions
"
RDEPEND="
	${DEPEND}
	dev-python/pygtk
"

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
