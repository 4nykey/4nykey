# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2

DESCRIPTION="TTA1 lossless audio encoder/decoder"

KEYWORDS="~x86"
SLOT="0"
LICENSE="GPL-2 LGPL-2.1"
IUSE=""
HOMEPAGE="http://www.true-audio.com"
SRC_URI="${HOMEPAGE}/ftp/${P/a/aenc}-src.zip"

S="${WORKDIR}"

src_compile() {
	sed -i '/^CFLAGS/d' Makefile
	emake
}

src_install() {
	dobin ttaenc
	dodoc Readme
}
