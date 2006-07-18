# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/emelfm2/emelfm2-0.0.9-r1.ebuild,v 1.5 2005/06/12 12:10:28 swegener Exp $

inherit flag-o-matic toolchain-funcs

DESCRIPTION="A file manager that implements the popular two-pane design based on gtk+-2"
HOMEPAGE="http://emelfm2.net/"
SRC_URI="http://emelfm2.net/rel/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~ppc ~amd64"
IUSE="nls fam"
RESTRICT="test" # requires splint

RDEPEND=">=x11-libs/gtk+-2.4
	virtual/fam"
DEPEND="${RDEPEND}"

pkg_setup() {
	filter-ldflags -Wl,--as-needed
}

src_unpack() {
	unpack ${A}
}

src_compile() {
	local myconf

	use nls && myconf="-DENABLE_NLS"
	emake PREFIX=/usr \
		CC="$(tc-getCC) ${CFLAGS}" \
		NLS=${myconf} || die "emake failed"
}

src_install() {
	local myconf

	use nls && myconf="-DENABLE_NLS"
	dodir /usr/bin

	make PREFIX=${D}/usr \
		NLS=${myconf} \
		DOC_DIR=${D}/usr/share/doc/${PF} \
		install || die "make install failed"
	prepalldocs
}
