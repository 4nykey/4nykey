# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit subversion autotools

DESCRIPTION="A curses client for the Music Player Daemon (MPD)"
HOMEPAGE="http://www.musicpd.org/?page=ncmpc"
ESVN_REPO_URI="https://svn.musicpd.org/ncmpc/branches/tradiaz"
ESVN_PATCHES="${PN}-*.patch"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="nls unicode lyrics raw-mode mouse debug"

RDEPEND="
	sys-libs/ncurses
	dev-libs/popt
	nls? ( >=dev-libs/glib-2.4 )
	lyrics? (
		>=dev-libs/glib-2.4
		net-misc/curl
		dev-libs/expat
		)
	!media-sound/ncmpc
	!media-sound/ncmpc-live
"
DEPEND="${RDEPEND}"

src_unpack() {
	subversion_src_unpack
	cd ${S}
	# hackery-moo
	install /usr/share/automake/mkinstalldirs .
	AT_M4DIR="m4" eautoreconf
}

src_compile() {
	econf \
		$(use_enable unicode ncursesw) \
		$(use_enable !unicode ncurses) \
		$(use_enable lyrics lyrics-screen) \
		$(use_enable raw-mode) \
		$(use_enable debug) \
		$(use_enable mouse) \
		$(use_enable nls) \
		--enable-artist-screen \
		--enable-search-screen \
		--enable-key-screen \
		--enable-clock-screen \
		|| die "econf failed"

		emake || die "make failed"
}																																	

src_install() {
	make install DESTDIR=${D} docdir=/usr/share/doc/${PF} || die
	dodoc AUTHORS ChangeLog NEWS README TODO doc/*.sample doc/ncmpc.lirc
	doman doc/ncmpc.1
}
