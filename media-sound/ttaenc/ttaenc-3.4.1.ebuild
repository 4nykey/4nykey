# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

MY_P="${P}-src"
DESCRIPTION="TTA lossless audio encoder/decoder"
HOMEPAGE="http://tta.sf.net"
SRC_URI="
	mirror://sourceforge/tta/${MY_P}.tgz
	http://etree.org/shnutils/shntool/support/formats/tta/unix/${PV}/${MY_P}-shntool.patch
"
S="${WORKDIR}/${MY_P}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND=""
RDEPEND=""

src_unpack() {
	unpack ${MY_P}.tgz
	cd ${S}
	sed -i -e "s:gcc:$(tc-getCC):g" Makefile
	epatch ${DISTDIR}/${MY_P}-shntool.patch
}

src_compile() {
	emake CFLAGS="${CFLAGS}" || die
}

src_install() {
	dobin ttaenc
	dodoc ChangeLog* README
}
