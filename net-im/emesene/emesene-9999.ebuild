# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit distutils subversion

DESCRIPTION="A PyGTK MSN messenger client"
HOMEPAGE="http://www.emesene.org"
ESVN_REPO_URI="https://emesene.svn.sourceforge.net/svnroot/emesene/trunk"
ESVN_PATCHES="${PN}-*.diff"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND=""
RDEPEND="
	dev-python/pygtk
"

src_unpack() {
	subversion_src_unpack
	mv emesene/setup.py .
}

