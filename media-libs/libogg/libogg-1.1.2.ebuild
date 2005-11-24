# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/libogg/libogg-1.1.2.ebuild,v 1.10 2005/02/09 11:33:28 lu_zero Exp $

inherit eutils subversion

DESCRIPTION="the Ogg media file format library"
HOMEPAGE="http://www.xiph.org/ogg/vorbis/index.html"
#SRC_URI="http://downloads.xiph.org/releases/ogg/${P}.tar.gz"
ESVN_REPO_URI="http://svn.xiph.org/trunk/ogg"
ESVN_PATCHES="autog_skipconf.diff"
ESVN_BOOTSTRAP="./autogen.sh"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~x86"
IUSE="static"

DEPEND="virtual/libc"

src_compile() {
	econf `use_enable static` || die
	emake || die
}

src_install() {
	make DESTDIR="${D}" install || die "make install failed"
}
