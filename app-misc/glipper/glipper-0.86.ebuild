# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="Clipboardmanager for GNOME"
HOMEPAGE="http://sourceforge.net/projects/glipper/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND=">=x11-libs/gtk+-2.6.0"
RDEPEND="${DEPEND}"

src_install() {
	einstall || die
	dodoc AUTHORS ChangeLog NEWS README
}
