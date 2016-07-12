# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit toolchain-funcs

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
PATCHES=( "${DISTDIR}"/${MY_P}-shntool.patch )

src_prepare() {
	sed -i -e "s:gcc:$(tc-getCC):g" Makefile
	default
}

src_compile() {
	emake CFLAGS="${CFLAGS}"
}

src_install() {
	dobin ttaenc
	dodoc ChangeLog* README
}
