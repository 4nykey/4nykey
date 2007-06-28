# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="A converter between many dictionary formats (dictd, dsl, sdict, stardict, xdxf)"
HOMEPAGE="http://xdxf.sf.net"
SRC_URI="mirror://sourceforge/xdxf/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="doc"

RDEPEND="
	sys-libs/zlib
	>=dev-libs/glib-2.6.0
	dev-libs/expat
	virtual/python
"
DEPEND="
	${RDEPEND}
	doc? ( app-doc/doxygen )
"

src_unpack() {
	unpack ${A}
	cd ${S}
	grep -rl /tmp tests | xargs sed -i "s:/tmp:${T}:g"
	sed -i 's:bin\(dir)/makedict-codecs\):data\1:' src/Makefile.in
}

src_compile() {
	econf \
		$(use_enable doc doxygen-docs) \
		|| die
	emake || die
}

src_install() {
	einstall || die
	emake datadir="${D}"/usr/share -C src install-plugins || die
	dodoc AUTHORS ChangeLog README TODO
}
