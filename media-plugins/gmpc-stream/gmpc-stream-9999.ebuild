# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit gmpc-plugin

DESCRIPTION="Online Stream Browser plugin for GMPC"
ESVN_REPO_URI="https://svn.qballcow.nl/${PN}/trunk"

KEYWORDS="~x86"
LICENSE="GPL-2"
SLOT="0"
IUSE=""

RDEPEND="
	${RDEPEND}
	=gnome-base/gnome-vfs-2*
"
