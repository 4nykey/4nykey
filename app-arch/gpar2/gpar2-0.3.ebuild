# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="A PAR 2.0 compatible file verification and repair GUI"
HOMEPAGE="http://parchive.sourceforge.net/"
SRC_URI="mirror://sourceforge/parchive/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND="dev-libs/libpar2
	>=dev-cpp/gtkmm-2.4"

src_install() {
	einstall || die
	dodoc AUTHORS ChangeLog README
}
