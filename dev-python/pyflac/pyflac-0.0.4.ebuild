# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit distutils subversion

DESCRIPTION="pyflac provides Python wrappers to libFLAC"
HOMEPAGE="http://lists.xiph.org/pipermail/flac-dev/2004-August/001571.html"

ESVN_REPO_URI="http://svn.sacredchao.net/svn/quodlibet/trunk/pyflac"
LICENSE="GPL-2"
SLOT="0"

KEYWORDS="~x86"
IUSE=""

RDEPEND=">=media-libs/flac-1.1.2
	>=dev-lang/python-2.3"

DEPEND="${RDEPEND}
	>=dev-lang/swig-1.3.21"

DOCS="README"

src_compile() {
	emake || die
}
