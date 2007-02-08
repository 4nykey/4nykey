# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit subversion distutils

DESCRIPTION="The Console Jabber Client - Jabber client with text-based user interface"
HOMEPAGE="http://jabberstudio.org/projects/cjc/project/view.php/"
ESVN_REPO_URI="http://cjc.jajcus.net/svn/cjc/trunk"
ESVN_PATCHES="${PN}-*.patch"

LICENSE="GPL-2"
SLOT="0"

KEYWORDS="~x86"

IUSE="doc"
DEPEND="
	doc? ( dev-libs/libxslt app-text/docbook-xsl-stylesheets )
"
RDEPEND="
	=net-im/pyxmpp-9999
"

src_compile() {
	mkdir .svn
	emake || die
}

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc README TODO
	use doc && dohtml doc/manual.html
}
