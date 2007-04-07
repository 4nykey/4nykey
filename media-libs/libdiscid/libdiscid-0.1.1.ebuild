# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="A library for creating MusicBrainz DiscIDs from audio CDs"
HOMEPAGE="http://wiki.musicbrainz.org/libdiscid"
SRC_URI="http://users.musicbrainz.org/~matt/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND=""
RDEPEND=""

src_install() {
	einstall || die
	dodoc AUTHORS ChangeLog README
}
