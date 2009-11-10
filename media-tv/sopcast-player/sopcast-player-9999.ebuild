# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
inherit python subversion

DESCRIPTION="SopCast Player is a Linux GUI front-end for the SopCast p2p streaming"
HOMEPAGE="http://code.google.com/p/sopcast-player/"
ESVN_REPO_URI="http://sopcast-player.googlecode.com/svn/trunk"

LICENSE=""
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="
	net-p2p/sopcast
"
DEPEND="
	sys-devel/gettext
"

src_compile() {
	emake PYTHON=@true || die
}

src_install() {
	emake DESTDIR="${D}" install || die
	dosed 's:@true:/bin/env python:' /usr/bin/sopcast-player
}

pkg_postinst() {
	python_mod_optimize /usr/share/${PN}
}

pkg_postrm() {
	python_mod_cleanup /usr/share/${PN}
}
