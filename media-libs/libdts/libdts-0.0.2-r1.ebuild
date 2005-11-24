# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/libdts/libdts-0.0.2-r1.ebuild,v 1.1 2005/03/26 11:15:12 eradicator Exp $

inherit eutils

DESCRIPTION="library for decoding DTS Coherent Acoustics streams used in DVD"
HOMEPAGE="http://www.videolan.org/dtsdec.html"
SRC_URI="http://www.videolan.org/pub/videolan/${PN}/${PV}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~ppc ~sparc ~amd64 ~hppa ~ppc64 ~alpha"
IUSE="oss debug static pic"

RDEPEND="virtual/libc"
DEPEND="${RDEPEND}
	sys-devel/libtool
	=sys-devel/automake-1.7*
	>=sys-devel/autoconf-2.52d-r1"

src_unpack() {
	unpack ${A}
	epatch ${FILESDIR}/${P}-libtool.patch
	epatch ${FILESDIR}/svn.diff

	cd ${S}

	export WANT_AUTOMAKE=1.7
	export WANT_AUTOCONF=2.5

	libtoolize --force --copy || die "libtoolize --force --copy failed"
	aclocal || die "aclocal failed"
	autoheader || die "autoheader failed"
	automake --gnu --add-missing --include-deps --force-missing --copy || die "automake failed"
	autoconf || die "autoconf failed"
}

src_compile() {
	econf \
		$(use_enable oss) \
		$(use_enable debug) \
		$(use_enable static) \
		$(use_enable !static shared) \
		$(use_with pic) || die
	emake || die "emake failed"
}

src_install() {
	make DESTDIR="${D}" install || die
	dodoc AUTHORS ChangeLog INSTALL NEWS README TODO doc/libdts.txt
}
