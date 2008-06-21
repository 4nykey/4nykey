# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/libdvdread/libdvdread-0.9.7.ebuild,v 1.17 2008/01/29 21:43:22 grobian Exp $

inherit subversion autotools

DESCRIPTION="Provides a simple foundation for reading DVD-Video images"
HOMEPAGE="http://www.dtek.chalmers.se/groups/dvd/"
ESVN_REPO_URI="svn://svn.mplayerhq.hu/dvdnav/trunk/${PN}"
ESVN_BOOTSTRAP="eautoreconf"
ESVN_PATCHES="${PN}-*.diff"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"
IUSE=""

DEPEND="
	>=media-libs/libdvdcss-1.1.1
"
RDEPEND="
	${DEPEND}
"

src_install() {
	einstall || die
	dosym libdvdread /usr/include/dvdread
	dodoc AUTHORS ChangeLog NEWS README TODO
}
