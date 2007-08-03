# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

MY_P="${PN}enc-${PV}-src"
DESCRIPTION="TTA lossless audio encoder/decoder"
HOMEPAGE="http://tta.sf.net"
SRC_URI="
	mirror://sourceforge/${PN}/${MY_P}.tgz
	http://etree.org/shnutils/shntool/support/formats/${PN}/${MY_P}-shntool.patch
"
S="${WORKDIR}/${MY_P}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND=""
RDEPEND=""

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch ${DISTDIR}/${MY_P}-shntool.patch
}

src_compile() {
	emake CFLAGS="${CFLAGS}" || die
}

src_install() {
	dobin ttaenc
	dodoc ChangeLog* README
}
