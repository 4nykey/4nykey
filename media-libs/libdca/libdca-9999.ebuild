# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit subversion autotools

DESCRIPTION="library for decoding DTS Coherent Acoustics streams used in DVD"
HOMEPAGE="http://developers.videolan.org/libdca.html"
ESVN_REPO_URI="svn://svn.videolan.org/${PN}/trunk"
ESVN_PATCHES="${PN}-*.diff"
ESVN_BOOTSTRAP="eautoreconf"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="oss debug"

DEPEND="
	oss? ( virtual/os-headers )
"

src_compile() {
	econf \
		--enable-shared \
		$(use_enable oss) \
		$(use_enable debug) \
		|| die
	emake \
		OPT_CFLAGS="${CFLAGS}" \
		DCADEC_CFLAGS="${CFLAGS}" \
		LIBDCA_CFLAGS= \
		|| die "emake failed"
}

src_install() {
	einstall || die
	dodoc AUTHORS ChangeLog NEWS README TODO doc/*.txt
	if has_version 'media-libs/libdts'; then
		rm -f ${D}usr/include/dts.h ${D}usr/lib/pkgconfig/libdts.pc \
			${D}usr/bin/dtsdec ${D}usr/share/man/man1/*dts*.1
	fi
}
