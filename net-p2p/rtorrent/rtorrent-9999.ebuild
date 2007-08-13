# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-p2p/rtorrent/rtorrent-0.7.4.ebuild,v 1.2 2007/05/24 15:47:04 drizzt Exp $

inherit subversion autotools toolchain-funcs flag-o-matic

AT_M4DIR="scripts"
DESCRIPTION="BitTorrent Client using libtorrent"
HOMEPAGE="http://libtorrent.rakshasa.no/"
ESVN_REPO_URI="svn://rakshasa.no/libtorrent/trunk/rtorrent"
ESVN_BOOTSTRAP="eautoreconf"
ESVN_PATCHES="${PN}-*.diff"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="-*"
IUSE="debug ipv6 openssl"

RDEPEND="
	>=dev-libs/libsigc++-2.0
	>=net-misc/curl-7.15
	sys-libs/ncurses
	openssl? ( dev-libs/openssl )
"
DEPEND="
	${RDEPEND}
	>=dev-util/pkgconfig-0.11
"

src_unpack() {
	ESVN_REPO_URI="svn://rakshasa.no/libtorrent/trunk/libtorrent" \
		subversion_fetch
	mv ${S} ${WORKDIR}/libtorrent
	subversion_fetch
	mv ${WORKDIR}/libtorrent ${S}
	sed -i ${S}/configure.ac -e 's:libtorrent >= [0-9.]*::'
	subversion_bootstrap
}

src_compile() {
	replace-flags -Os -O2
	append-flags -fno-strict-aliasing

	if [[ $(tc-arch) = "x86" ]]; then
		filter-flags -fomit-frame-pointer -fforce-addr

		# See bug #151221. It seems only to hit on GCC 4.1 and x86 architecture
		# it could be safer to fallback to -O1, but with the high use of STL in
		# rtorrent, that could make it too slow.
		[[ $(gcc-major-version)$(gcc-minor-version) == "41" ]] && replace-flags -O2 -O3
	fi

	CPPFLAGS="-I${S}/libtorrent/src ${CPPFLAGS}" \
	econf \
		$(use_enable debug) \
		$(use_enable ipv6) \
		$(use_enable openssl) \
		--disable-dependency-tracking \
		--disable-shared --enable-static \
		|| die "econf failed"

	emake -C libtorrent || die "libtorrent emake failed"
	emake || die "rtorrent emake failed"
}

pkg_postinst() {
	elog "rtorrent now supports a configuration file."
	elog "A sample configuration file for rtorrent is can be found"
	elog "in ${ROOT}usr/share/doc/${PF}/rtorrent.rc.gz."
}

src_install() {
	emake DESTDIR="${D}" install || die "make install failed"
	dodoc AUTHORS README TODO doc/rtorrent.rc
}
