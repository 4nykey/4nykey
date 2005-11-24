# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="Automatic command-line mp3/ogg file tagger"
HOMEPAGE="http://bgoglin.free.fr/lltag"
SRC_URI="http://bgoglin.free.fr/DOWNLOAD/packages/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"

RDEPEND="dev-lang/perl
	 media-sound/mp3info
	 media-sound/vorbis-tools"

src_compile() {
	make DESTDIR="${D}/" PREFIX=/usr SYSCONFDIR=/etc MANDIR=/usr/share/man \
	|| die "Failed to compile"
}

src_install() {
	make DESTDIR="${D}/" PREFIX=/usr SYSCONFDIR=/etc MANDIR=/usr/share/man \
	install || die "Failed to install"
	dodoc COPYING Changes
}
