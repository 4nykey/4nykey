# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-p2p/rtorrent/rtorrent-0.8.2-r4.ebuild,v 1.1 2008/08/07 22:00:07 loki_val Exp $

inherit autotools toolchain-funcs flag-o-matic subversion

DESCRIPTION="BitTorrent Client using libtorrent"
HOMEPAGE="http://libtorrent.rakshasa.no/"
ESVN_REPO_URI="svn://rakshasa.no/libtorrent/trunk/rtorrent"
ESVN_BOOTSTRAP="eautoreconf"
ESVN_PATCHES="${PN}-*.diff"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="debug ipv6 openssl xmlrpc"

RDEPEND="
	>=dev-libs/libsigc++-2
	net-misc/curl
	sys-libs/ncurses
	openssl? ( dev-libs/openssl )
	xmlrpc? ( dev-libs/xmlrpc-c )
"
DEPEND="
	${RDEPEND}
	dev-util/pkgconfig
	dev-util/cppunit
"

src_unpack() {
	subversion_fetch
	subversion_fetch svn://rakshasa.no/libtorrent/trunk/libtorrent src/libtorrent
	subversion_bootstrap
}

src_compile() {
	replace-flags -Os -O2
	append-flags -fno-strict-aliasing
	[[ $(tc-arch) = "x86" ]] && filter-flags -fomit-frame-pointer -fforce-addr

	libtorrent_CFLAGS="-I${S}/src/libtorrent/src" \
	libtorrent_LIBS=" " \
	econf \
		$(use_enable debug) \
		$(use_enable ipv6) \
		$(use_enable openssl) \
		$(use_with xmlrpc xmlrpc-c) \
		--disable-dependency-tracking \
		|| die "econf failed"

	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "make install failed"
	dodoc AUTHORS README TODO doc/rtorrent.rc
}
