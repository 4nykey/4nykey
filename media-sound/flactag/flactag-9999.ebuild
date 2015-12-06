# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit autotools-utils
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="git://flactag.git.sourceforge.net/gitroot/flactag/flactag"
else
	SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="A utility for tagging FLAC files via MusicBrainz"
HOMEPAGE="http://software.gently.org.uk/flactag/"

LICENSE="GPL-2"
SLOT="0"
IUSE="gcrypt"

RDEPEND="
	media-libs/musicbrainz:5
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

PATCHES=("${FILESDIR}"/${PN}*.diff)
AUTOTOOLS_AUTORECONF="1"
AUTOTOOLS_IN_SOURCE_BUILD="1"

src_configure() {
	local myeconfargs=(
		--docdir=/usr/share/doc/${PF}/html
		$(use_with gcrypt libgcrypt)
	)
	autotools-utils_src_configure
}
