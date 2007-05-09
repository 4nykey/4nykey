# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/libdvdnav/libdvdnav-0.1.10.ebuild,v 1.16 2006/12/27 17:34:43 vapier Exp $

inherit subversion autotools

DESCRIPTION="Library for DVD navigation tools"
HOMEPAGE="http://sourceforge.net/projects/dvd/"
ESVN_REPO_URI="svn://svn.mplayerhq.hu/dvdnav/trunk/libdvdnav2"
ESVN_BOOTSTRAP="eautoreconf"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}"

src_install () {
#	emake DESTDIR="${D}" install || die
	einstall || die
	dodoc AUTHORS ChangeLog NEWS README TODO
}
