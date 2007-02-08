# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit subversion distutils

DESCRIPTION="PyXMPP is a Python XMPP (RFC 3920,3921) and Jabber implementation"
HOMEPAGE="http://pyxmpp.jabberstudio.org/"
ESVN_REPO_URI="http://pyxmpp.jajcus.net/svn/pyxmpp/trunk"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND="
	>=dev-lang/python-2.3
	>=dev-libs/libxml2-2.6.23
"
RDEPEND="
	${DEPEND}
	>=dev-python/dnspython-1.5
	>=dev-python/m2crypto-0.17
"

pkg_setup() {
	if ! built_with_use dev-libs/libxml2 python ; then
		eerror "To build pyxmpp, libxml2 must be built with python"
		eerror "bindings. To continue merging pyxmpp, you must first "
		eerror "recompile libxml2 with the python use flag enabled"
		die "pyxmpp requires libxml2 with USE=python"
	fi
}

src_compile() {
	mkdir .svn
	emake version || die
	distutils_src_compile || die
}
