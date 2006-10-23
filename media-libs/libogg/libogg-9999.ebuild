# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/libogg/libogg-1.1.2.ebuild,v 1.10 2005/02/09 11:33:28 lu_zero Exp $

inherit subversion autotools

DESCRIPTION="the Ogg media file format library"
HOMEPAGE="http://www.xiph.org/ogg/vorbis/index.html"
ESVN_REPO_URI="http://svn.xiph.org/trunk/ogg"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~x86"
IUSE="doc"

src_unpack() {
	subversion_src_unpack
	cd ${S}
	if use doc; then
		sed -i "s:[$]\{1\}(VERSION):${PV}:" doc/{.,libogg}/Makefile.am
	else
		sed -i "s: \<doc\>::" Makefile.am
	fi
	eautoreconf
}

src_install() {
	make DESTDIR="${D}" install || die "make install failed"
}
