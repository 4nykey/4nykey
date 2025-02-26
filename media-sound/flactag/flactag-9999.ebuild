# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/adhawkins/${PN}.git"
else
	inherit vcs-snapshot
	MY_PV="dcf73ee"
	SRC_URI="mirror://githubcl/adhawkins/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="A utility for tagging FLAC files via MusicBrainz"
HOMEPAGE="http://software.gently.org.uk/flactag/"

LICENSE="GPL-2"
SLOT="0"
IUSE="+scripts gcrypt"

DEPEND="
	media-libs/musicbrainz:5
	media-libs/libdiscid
	media-libs/flac:=[cxx]
	sys-libs/slang
	app-text/unac
	virtual/jpeg
	gcrypt? ( dev-libs/libgcrypt:0 )
"
RDEPEND="
	${DEPEND}
	scripts? (
		app-cdr/cdrdao
		app-cdr/cuetools
		|| ( dev-libs/libcdio-paranoia media-sound/cdparanoia )
	)
"
BDEPEND="
	app-text/xmlto
	app-text/asciidoc
"

src_prepare() {
	local PATCHES=(
		"${FILESDIR}"/${PN}-libs.diff
		"${FILESDIR}"/${PN}-man.diff
	)
	default
	sed -e '/CDROM=/s:hdc:cdrom:' -i checkflac
	sed -e 's:doc_DATA:html_DATA:' -i Makefile.am
	use scripts || sed \
		-e 's:dist_bin_SCRIPTS:doc_DATA:' \
		-e 's:bin_SCRIPTS = :doc_DATA += :' \
		-i Makefile.am
	eautoreconf
}

src_configure() {
	local myeconfargs=(
		$(use_with gcrypt libgcrypt)
	)
	econf "${myeconfargs[@]}"
}
