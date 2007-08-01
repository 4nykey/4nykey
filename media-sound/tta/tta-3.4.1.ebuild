# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

MY_P="${PN}enc-${PV}-src"
DESCRIPTION="TTA lossless audio encoder/decoder"
HOMEPAGE="http://tta.sf.net"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tgz"
S="${WORKDIR}/${MY_P}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND=""
RDEPEND=""

src_compile() {
	emake CFLAGS="${CFLAGS}" || die
}

src_install() {
	dobin ttaenc
	dodoc ChangeLog* README
}
