# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-p2p/rtorrent/rtorrent-0.8.6-r1.ebuild,v 1.6 2010/07/04 13:23:28 ssuominen Exp $

EAPI="4"

inherit git-2 autotools-utils

DESCRIPTION="BitTorrent Client using libtorrent"
HOMEPAGE="http://libtorrent.rakshasa.no/"
EGIT_REPO_URI="git://github.com/rakshasa/rtorrent.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="debug ipv6 crypt xmlrpc"

PATCHES=("${FILESDIR}"/${PN}*.diff)
DOCS=(AUTHORS README doc/rtorrent.rc)

RDEPEND="
	dev-libs/libsigc++:2
	net-misc/curl
	sys-libs/ncurses
	crypt? ( dev-libs/openssl )
	xmlrpc? ( dev-libs/xmlrpc-c )
"
DEPEND="
	${RDEPEND}
	dev-util/pkgconfig
	dev-util/cppunit
"

src_unpack() {
	git-2_src_unpack
	EGIT_SOURCEDIR="${S}/src/libtorrent" \
	EGIT_REPO_URI="git://github.com/rakshasa/libtorrent.git" \
		git-2_src_unpack
}

src_prepare() {
	#autotools-utils_src_prepare #autotools_get_subdirs returns nada
	epatch "${PATCHES[@]}"
	eautoreconf
}

src_configure() {
	local myeconfargs=(
		--disable-dependency-tracking
		--enable-aligned
		--with-posix-fallocate
		$(use_enable debug)
		$(use_enable ipv6)
		$(use_enable crypt openssl)
		$(use_with xmlrpc xmlrpc-c)
	)
	libtorrent_CFLAGS="-I${S}/src/libtorrent/src" \
	libtorrent_LIBS=" " \
	autotools-utils_src_configure
}
