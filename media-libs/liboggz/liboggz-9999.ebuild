# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit subversion autotools

DESCRIPTION="Oggz provides a simple interface for reading and writing Ogg files."
HOMEPAGE="http://www.annodex.net/software/liboggz"
SRC_URI=""
ESVN_REPO_URI="http://svn.annodex.net/liboggz/trunk"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND="
	media-libs/libogg
"
RDEPEND="
	$RDEPEND
"

src_unpack() {
	subversion_src_unpack
	cd ${S}
	AT_M4DIR="m4" eautoreconf
}

src_install() {
	einstall || die
}
