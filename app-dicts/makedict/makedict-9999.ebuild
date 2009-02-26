# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit subversion cmake-utils

DESCRIPTION="A converter between many dictionary formats (dictd, dsl, sdict, stardict, xdxf)"
HOMEPAGE="http://xdxf.sf.net"
ESVN_REPO_URI="https://xdxf.svn.sourceforge.net/svnroot/xdxf/trunk"
ESVN_PATCHES="${PN}-*.diff"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="verbose-build"
DOCS="AUTHORS ChangeLog NEWS README TODO"

DEPEND="
	sys-libs/zlib
	>=dev-libs/glib-2.6.0
	dev-libs/expat
"
RDEPEND="
	${DEPEND}
	virtual/python
"

pkg_setup() {
	use verbose-build && CMAKE_COMPILER_VERBOSE=y
}
