# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit eutils

DESCRIPTION="A utility for tagging FLAC files with embedded CUE sheets via MusicBrainz"
HOMEPAGE="http://software.gently.org.uk/flactag/"
SRC_URI="http://software.gently.org.uk/${P}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	media-libs/musicbrainz:3
	media-libs/libdiscid
	media-libs/flac[cxx]
	sys-libs/slang
	net-libs/neon
	app-text/unac
	media-libs/jpeg
"
DEPEND="
	${RDEPEND}
	app-text/docbook2X
	app-text/asciidoc
"

src_prepare() {
	epatch "${FILESDIR}"/${PN}*.diff
}

src_install() {
	dobin flactag discid
	doman flactag.1
	dohtml -r .
	docinto examples
	dodoc checkflac ripdataflac ripflac
	insinto /var/lib/flactag
	doins tocfix.sed
}
