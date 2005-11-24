# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils toolchain-funcs

DESCRIPTION="ReplayGain for wave files"
HOMEPAGE="http://www.rarewares.org/files/others"
SRC_URI="http://www.rarewares.org/files/others/${P}srcs.zip"
S="${WORKDIR}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND="app-arch/unzip"
RDEPEND=""

src_compile(){
	sed -i 's:stdin\.:stdin.\\n:' main.c
	`tc-getCC` -DHAVE_CONFIG_H ${CFLAGS} ${LDFLAGS} -o wavegain *.c -lm
}

src_install(){
	dobin wavegain
}

