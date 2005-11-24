# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit mono eutils gnome2

DESCRIPTION="A client for the Music Player Daemon (MPD)"
HOMEPAGE="http://pympc.sourceforge.net/mpcsharp"
SRC_URI="${HOMEPAGE}/${P}.tar.gz"

LICENSE="GPL-2"
IUSE=""
KEYWORDS="~x86"

DEPEND=">=dev-lang/mono-1.1.2
	>=dev-dotnet/gtk-sharp-1.9.2
	>=dev-dotnet/gnome-sharp-1.9.2
	>=dev-dotnet/glade-sharp-1.9.2
	>=dev-dotnet/gconf-sharp-1.9.2
	>=gnome-base/gconf-2.0.0
	>=x11-libs/gtk+-2.6.0"

src_unpack() {
	unpack ${A}
	cd ${S}
	WANT_AUTOMAKE=1.6 autoreconf -fi
}

src_install() {
	gnome2_src_install || die
	exeinto /usr/bin
	doexe ${FILESDIR}/${PN}
	make_desktop_entry mpcsharp MpcSharp gnome-audio
}
