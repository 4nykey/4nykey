# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libebml/libebml-0.7.5.ebuild,v 1.1 2005/07/14 12:23:45 flameeyes Exp $

IUSE=""

inherit flag-o-matic eutils

DESCRIPTION="Extensible binary format library (kinda like XML)"
HOMEPAGE="http://www.matroska.org/"
SRC_URI="http://www.bunkus.org/videotools/mkvtoolnix/sources/${P}.tar.bz2"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~x86"

DEPEND=""
RDEPEND=""

src_unpack() {
	unpack ${A}

	cd ${S}

	sed -i -e 's:CXXFLAGS=:CXXFLAGS+=:g' ${S}/make/linux/Makefile
}

src_compile() {
	cd ${S}/make/linux

	emake PREFIX=/usr || die "make failed"
}

src_install() {
	cd ${S}/make/linux
	einstall libdir="${D}/usr/$(get_libdir)" || die "make install failed"
	dodoc ${S}/ChangeLog
}
