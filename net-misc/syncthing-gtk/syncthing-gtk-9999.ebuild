# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=(python2_7)
DISTUTILS_SINGLE_IMPL="1"
inherit gnome2-utils fdo-mime distutils-r1
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/${PN%-*}/${PN}.git"
else
	inherit vcs-snapshot
	SRC_URI="mirror://githubcl/${PN%-*}/${PN}/tar.gz/v${PV} -> ${P}.tar.gz"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi
DESCRIPTION="GTK3 & python based GUI for Syncthing"
HOMEPAGE="https://github.com/syncthing/syncthing-gtk"

LICENSE="GPL-2"
SLOT="0"
IUSE="inotify"

RDEPEND="
	x11-libs/gtk+:3[introspection]
	dev-python/pygobject:3
	dev-python/python-dateutil
	net-misc/syncthing
	inotify? ( dev-python/pyinotify )
"
DEPEND="
	${RDEPEND}
	dev-python/setuptools
"

src_prepare() {
	sed -e 's:Categories=.*:&\;:' -i syncthing-gtk.desktop
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	fdo-mime_desktop_database_update
	gnome2_icon_cache_update
}

pkg_postrm() {
	fdo-mime_desktop_database_update
	gnome2_icon_cache_update
}
