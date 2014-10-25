# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit cmake-utils git-r3

DESCRIPTION="A converter between many dictionary formats (dictd, dsl, sdict, stardict, xdxf)"
HOMEPAGE="http://xdxf.sf.net"
EGIT_REPO_URI="https://github.com/soshial/xdxf_makedict.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""
PATCHES=( "${FILESDIR}"/${PN}-*.diff )
DOCS=( AUTHORS CHANGELOG README TODO )

DEPEND="
	sys-libs/zlib
	>=dev-libs/glib-2.6.0
	dev-libs/expat
"
RDEPEND="
	${DEPEND}
	virtual/python
"
