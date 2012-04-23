# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

DESCRIPTION="A utility for tagging FLAC files with embedded CUE sheets via MusicBrainz"
HOMEPAGE="http://software.gently.org.uk/flactag/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gcrypt"

RDEPEND="
	media-libs/musicbrainz:4
	media-libs/libdiscid
	media-libs/flac[cxx]
	sys-libs/slang
	net-libs/neon
	app-text/unac
	virtual/jpeg
	gcrypt? ( dev-libs/libgcrypt )
"
DEPEND="
	${RDEPEND}
	app-text/xmlto
	app-text/asciidoc
"

src_configure() {
	econf \
		$(use_with gcrypt libgcrypt) \
		--docdir=/usr/share/doc/${PF}/html
}
