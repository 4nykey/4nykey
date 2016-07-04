# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-p2p/rtorrent/rtorrent-0.8.6-r1.ebuild,v 1.6 2010/07/04 13:23:28 ssuominen Exp $

EAPI=6

inherit autotools git-r3

DESCRIPTION="BitTorrent Client using libtorrent"
HOMEPAGE="http://libtorrent.rakshasa.no/"
EGIT_REPO_URI="git://github.com/rakshasa/rtorrent.git"

LICENSE="GPL-2"
SLOT="0"
IUSE="c++0x debug ipv6 libressl ssl xmlrpc"

PATCHES=( "${FILESDIR}"/${PN}-noinst_libtorrent.diff )
DOCS=( AUTHORS README doc/rtorrent.rc )

RDEPEND="
	dev-libs/libsigc++:2
	net-misc/curl
	sys-libs/ncurses
	ssl? (
	    !libressl? ( dev-libs/openssl:0 )
	    libressl? ( dev-libs/libressl )
	)
	xmlrpc? ( dev-libs/xmlrpc-c )
"
DEPEND="
	${RDEPEND}
	virtual/pkgconfig
	dev-util/cppunit
"

src_prepare() {
	default
	eautoreconf
}

src_unpack() {
	git-r3_src_unpack
	EGIT_CHECKOUT_DIR="${S}/src/libtorrent" \
	EGIT_REPO_URI="git://github.com/rakshasa/libtorrent.git" \
		git-r3_src_unpack
}

src_configure() {
	local myeconfargs=(
		--disable-dependency-tracking
		--enable-aligned
		--with-posix-fallocate
		$(use_enable c++0x)
		$(use_enable debug)
		$(use_enable ipv6)
		$(use_enable ssl openssl)
		$(use_with xmlrpc xmlrpc-c)
	)
	libtorrent_CFLAGS="-I${S}/src/libtorrent/src" \
	libtorrent_LIBS=" " \
		econf "${myeconfargs[@]}"
}
