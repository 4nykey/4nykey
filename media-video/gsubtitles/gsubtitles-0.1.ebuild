# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit mono

MY_P="gnome-subtitles-${PV}"
DESCRIPTION="Gnome Subtitles is a subtitle editor for the GNOME desktop"
HOMEPAGE="http://gsubtitles.sf.net"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

RDEPEND="
	>=dev-dotnet/gnome-sharp-2.8
	>=dev-dotnet/glade-sharp-2.8
"
DEPEND="
	${RDEPEND}
	dev-util/pkgconfig
"

src_install() {
	einstall || die
	dodoc AUTHORS ChangeLog NEWS README TODO
	# let's make it one `gnome-foo' less
	OL="usr/bin/gnome-subtitles"
	NU="usr/bin/gsubtitles"
	mv ${D}${OL} ${D}${NU}
	dosed "s:${OL}:${NU}:" /usr/share/applications/gnome-subtitles.desktop
}
