# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/libmatroska/libmatroska-0.8.0.ebuild,v 1.13 2006/12/03 06:29:23 vapier Exp $

inherit flag-o-matic subversion toolchain-funcs

DESCRIPTION="Extensible multimedia container format based on EBML"
HOMEPAGE="http://www.matroska.org/"
ESVN_REPO_URI="http://svn.matroska.org/svn/matroska/trunk/libmatroska"
ESVN_PATCHES="${PN}-respectflags.patch"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND=">=dev-libs/libebml-0.7.7"

src_compile() {
	#fixes locale for gcc3.4.0 to close bug 52385
	append-flags $(test-flags -finput-charset=ISO8859-15)

	emake -C make/linux PREFIX=/usr \
		LIBEBML_INCLUDE_DIR=/usr/include/ebml \
		LIBEBML_LIB_DIR=/usr/$(get_libdir) \
		CXX="$(tc-getCXX)" || die "make failed"
}

src_install() {
	cd make/linux

	einstall libdir="${D}/usr/$(get_libdir)" || die "make install failed"
	dodoc ${S}/ChangeLog
}
