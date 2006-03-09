# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2

inherit gnome2 mono

DESCRIPTION="CDCollect is a CD catalog application for Gnome"
HOMEPAGE="http://cdcollect.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

RDEPEND=">=dev-lang/mono-1.1.8
	>=dev-dotnet/gtk-sharp-1.9.5
	>=dev-dotnet/gnome-sharp-1.9.5
	>=dev-dotnet/glade-sharp-1.9.5
	>=dev-dotnet/gnomevfs-sharp-1.9.5
	=dev-db/sqlite-2*"
DEPEND="${RDEPEND}"

G2CONF="--enable-compile-warnings=no"

DOCS="ChangeLog NEWS README AUTHORS TODO COPYING"
