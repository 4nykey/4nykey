# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/ncmpc/ncmpc-0.11.0.ebuild,v 1.4 2004/09/15 17:16:59 eradicator Exp $

inherit subversion autotools

IUSE="nls"

DESCRIPTION="A ncurses client for the Music Player Daemon (MPD)"
HOMEPAGE="http://www.musicpd.org/?page=ncmpc"
ESVN_REPO_URI="https://svn.musicpd.org/${PN}/trunk"
ESVN_PATCHES="*.patch"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="~x86"

RDEPEND="sys-libs/ncurses
	dev-libs/popt
	>=dev-libs/glib-2.4"
DEPEND="${RDEPEND}"

src_unpack() {
	subversion_src_unpack
	cd ${S}
	AT_M4DIR="${S}/m4" eautoreconf || die
}

src_compile() {
	econf `use_enable nls` \
		--enable-artist-screen || die
	emake || die
}

src_install() {
	make install DESTDIR=${D} docdir=/usr/share/doc/${PF} \
		|| die "install failed"
	prepalldocs
}
