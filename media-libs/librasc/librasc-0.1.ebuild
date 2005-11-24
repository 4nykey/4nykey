# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="a library to download sound samples from websites directly into audio applications"
HOMEPAGE="http://librasc.org/"
SRC_URI="mirror://sourceforge/libsampleremote/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND=">=net-misc/curl-7.13.2
	>=dev-libs/libxml2-2.6.11"
RDEPEND="${DEPEND}"

src_install() {
	make DESTDIR="${D}" install || die
	dodoc AUTHORS ChangeLog NEWS README
}
