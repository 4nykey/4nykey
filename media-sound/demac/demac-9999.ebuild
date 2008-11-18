# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit subversion

DESCRIPTION="demac - a decoder for Monkey's Audio files"
HOMEPAGE="http://rockbox.org"
ESVN_REPO_URI="svn://svn.rockbox.org/rockbox/trunk/apps/codecs/demac"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND=""
RDEPEND=""

src_compile() {
	emake CC="$(tc-getCC)" CFLAGS="${CFLAGS} -Ilibdemac" || die
}

src_install() {
	dobin demac
	dodoc README
}
