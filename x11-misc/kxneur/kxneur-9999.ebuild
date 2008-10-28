# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit kde subversion

DESCRIPTION="X Neural Switcher front-end for KDE"
HOMEPAGE="http://xneur.ru"
ESVN_REPO_URI="svn://xneur.ru:3690/xneur/kxneur"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

RDEPEND="
	kde-base/kdelibs
	=x11-misc/xneur-${PV}*
"
DEPEND="
	${RDEPEND}
	x11-libs/libxkbfile
"

pkg_setup() {
	set-kdedir
	kde_pkg_setup
}
