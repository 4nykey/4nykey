# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit subversion

DESCRIPTION="Oggz provides a simple programming interface for reading and
writing Ogg files and streams."
HOMEPAGE="http://www.annodex.net/software/liboggz"
SRC_URI=""
ESVN_REPO_URI="http://svn.annodex.net/liboggz/trunk"
ESVN_BOOTSTRAP="WANT_AUTOMAKE=1.6 ./autogen.sh"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND="media-libs/libogg"
RDEPEND="$RDEPEND"

src_install() {
	einstall || die
}
