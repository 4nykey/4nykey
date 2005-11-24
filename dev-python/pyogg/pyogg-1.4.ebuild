# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/pyogg/pyogg-1.3-r1.ebuild,v 1.6 2005/04/21 19:00:24 hansmi Exp $

inherit distutils subversion

DESCRIPTION="Python bindings for the ogg library"
HOMEPAGE="http://www.andrewchatham.com/pyogg/"
# Grumble. They changed the tarball without changing the name..
#SRC_URI="http://www.andrewchatham.com/pyogg/download/${P}.tar.gz"
#SRC_URI="http://dev.gentoo.org/~kloeri/${P}-r1.tar.gz"
ESVN_REPO_URI="http://svn.xiph.org/trunk/ogg-python"

IUSE=""
LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="x86 ppc ~alpha ~mips sparc hppa amd64 ppc64"

DEPEND="dev-lang/python
	>=media-libs/libogg-1.0"

src_compile() {
	./config_unix.py || die
	distutils_src_compile
}

DOCS="AUTHORS COPYING ChangeLog NEWS README"

