# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libebml/libebml-0.7.6.ebuild,v 1.10 2006/05/08 07:40:11 corsair Exp $

inherit toolchain-funcs flag-o-matic

IUSE=""

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
	sed -i 's:\$(CXX) -shared:$(CXX) $(LDFLAGS) -shared:' ${S}/make/linux/Makefile
}

src_compile() {
	cd ${S}/make/linux
	emake PREFIX=/usr CXX="$(tc-getCXX)"|| die "make failed"
}

src_install() {
	cd ${S}/make/linux
	einstall libdir="${D}/usr/$(get_libdir)" || die "make install failed"
	dodoc ${S}/ChangeLog
}
