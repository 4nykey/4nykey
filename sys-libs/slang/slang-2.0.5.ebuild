# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-libs/slang/slang-1.4.9-r2.ebuild,v 1.1 2005/05/16 14:51:33 lanius Exp $

inherit autotools

# Patches are taken from http://www.suse.de/~nadvornik/slang/
# They were originally Red Hat and Debian's patches

DESCRIPTION="Console display library used by most text viewer"
HOMEPAGE="http://www.s-lang.org/"
SRC_URI="ftp://space.mit.edu/pub/davis/slang/v2.0/${P}.tar.bz2"

LICENSE="|| ( GPL-2 Artistic )"
SLOT="0"
KEYWORDS="~x86"
#IUSE="cjk unicode"
IUSE=""

DEPEND=">=sys-libs/ncurses-5.2-r2"

src_unpack() {
	unpack ${P}.tar.bz2
	cd ${S}

	epatch ${FILESDIR}/${P}.patch
	#use ppc-macos || epatch ${FILESDIR}/${P}-fsuid.patch
	epatch ${FILESDIR}/${P}-autoconf.patch

	# enabling cjk breaks compilation
	#if use cjk ; then
	#	sed -i \
	#		-e "/SLANG_HAS_KANJI_SUPPORT/s/0/1/" \
	#		src/sl-feat.h
	#fi

	# link slsh against built lib, not the one installed in live system
	sed -i 's:(SLANG_INST_LIB):(SLANG_SRCLIB):'  slsh/Makefile.in

	ln -s autoconf/configure.ac
	ln -s autoconf/aclocal.m4
	eautoreconf || die
}

src_compile() {
	econf || die "econf failed"
	emake -j1 all elf || die "make failed"
}

src_install() {
	make install install-elf DESTDIR=${D} || die "make install failed"
	chmod a+rx "${D}"/usr/$(get_libdir)/{,slang/v2/modules}/*.so* || die "chmod failed"

	rm -rf ${D}/usr/doc
	dodoc NEWS README *.txt
	dodoc doc/*.txt doc/internal/*.txt doc/text/*.txt
	dohtml doc/*.html
}
