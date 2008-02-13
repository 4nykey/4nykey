# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit kde subversion

DESCRIPTION="X Neural Switcher front-end for KDE"
HOMEPAGE="http://xneur.ru"
ESVN_REPO_URI="svn://xneur.ru:3690/xneur/kxneur"
#ESVN_BOOTSTRAP="make -f admin/Makefile.common configure.in acinclude.m4 && eautoreconf"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="-*"
IUSE=""

RDEPEND="
	kde-base/kdelibs
	=x11-misc/xneur-${PV}*
"
DEPEND="
	${RDEPEND}
	x11-libs/libxkbfile
"
