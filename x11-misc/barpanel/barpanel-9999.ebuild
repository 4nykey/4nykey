# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit distutils git

DESCRIPTION="BarPanel is a powerful desktop panel"
HOMEPAGE="http://www.ossproject.org/projects/barpanel"
EGIT_REPO_URI="git://www.ossproject.org/barpanel.git"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="battery"

RDEPEND="
	>=dev-python/pygtk-2.6.0
	dev-python/pyxdg
	dev-python/gnome-python-desktop
	battery? ( dev-python/dbus-python sys-apps/hal )
"
DEPEND=""

