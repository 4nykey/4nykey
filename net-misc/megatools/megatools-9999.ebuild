# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/megatools/megatools-1.9.93.ebuild,v 1.1 2014/11/21 14:56:08 dlan Exp $

EAPI=5

AUTOTOOLS_AUTORECONF=1
AUTOTOOLS_IN_SOURCE_BUILD=1
inherit autotools-utils
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/megous/${PN}.git"
else
	SRC_URI="mirror://githubcl/megous/${PN}/tar.gz/${PV} -> ${P}.tar.gz"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="Command line tools and C library for accessing Mega cloud storage"
HOMEPAGE="http://megatools.megous.com"

LICENSE="GPL-2"
SLOT="0"
IUSE="fuse introspection static-libs"

DEPEND="
	dev-libs/glib:2
	dev-libs/openssl:0
	net-misc/curl
	fuse? ( sys-fs/fuse )
"
RDEPEND="
	${DEPEND}
	net-libs/glib-networking[ssl]
"
DEPEND="
	${DEPEND}
	virtual/pkgconfig
	app-text/asciidoc
"

src_configure() {
	local myeconfargs=(
		--enable-shared
		--enable-docs-build
		--disable-maintainer-mode
		--disable-warnings
		--disable-glibtest
		$(use_enable static-libs static)
		$(use_enable introspection)
		$(use_with fuse)
	)
	autotools-utils_src_configure
}
