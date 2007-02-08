# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit subversion python

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
	mkdir -p .svn
	emake || die
	use doc && emake -C doc
}

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc README TODO
	use doc && dohtml doc/manual.html
}

pkg_postinst() {
	python_mod_optimize ${ROOT}usr/lib/cjc
}

pkg_postrm() {
	python_mod_cleanup ${ROOT}usr/lib/cjc
}
