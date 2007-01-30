# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit mono gnome2

MY_PN="DesktopDataManager"
DESCRIPTION="A clipboard manager and screenshot taking application"
HOMEPAGE="http://data-manager.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN/desktop-/}/${PN}_${PV}_src.tar.gz"
S="${WORKDIR}/${MY_PN}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

RDEPEND="
	>=dev-dotnet/glade-sharp-2.8
	>=dev-dotnet/gconf-sharp-2.8
"
DEPEND="
	${RDEPEND}
"

DOCS="AUTHORS ChangeLog"
