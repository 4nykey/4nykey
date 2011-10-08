# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"
inherit python gnome2 subversion

DESCRIPTION="SopCast Player is a Linux GUI front-end for the SopCast p2p streaming"
HOMEPAGE="http://code.google.com/p/sopcast-player/"
SRC_URI=""
ESVN_REPO_URI="http://sopcast-player.googlecode.com/svn/trunk"

LICENSE=""
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	net-p2p/sopcast
	media-video/vlc
"
DEPEND="
	sys-devel/gettext
"

src_configure() {
	:
}

src_compile() {
	emake PYTHON="@true" || die
}

src_install() {
	gnome2_src_install
	dosed 's:@true:/bin/env python:' /usr/bin/sopcast-player
}

pkg_postinst() {
	python_mod_optimize /usr/share/${PN}
	gnome2_pkg_postinst
}

pkg_postrm() {
	python_mod_cleanup /usr/share/${PN}
	gnome2_pkg_postrm
}
