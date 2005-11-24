# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/pyvorbis/pyvorbis-1.4.ebuild,v 1.1 2004/12/07 02:41:46 kloeri Exp $

inherit subversion distutils

DESCRIPTION="Python bindings for libmusepack"
HOMEPAGE="http://svn.sacredchao.net/svn/quodlibet/trunk/pymusepack"
ESVN_REPO_URI="http://svn.sacredchao.net/svn/quodlibet/trunk/pymusepack"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND="dev-lang/python
	media-libs/libmpcdec"

src_compile() {
	./setup.py build || die
	distutils_src_compile
}

DOCS="AUTHORS ChangeLog NEWS README"

