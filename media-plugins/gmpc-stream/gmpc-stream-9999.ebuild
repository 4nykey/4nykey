# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit gmpc-plugin

ESVN_REPO_URI="https://svn.qballcow.nl/${PN}/trunk"

RDEPEND="
	${RDEPEND}
	=gnome-base/gnome-vfs-2*
"
