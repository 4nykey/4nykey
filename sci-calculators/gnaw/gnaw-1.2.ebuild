# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit toolchain-funcs

DESCRIPTION="GNAW is a command-line calculator written in C++"
HOMEPAGE="http://gnaw.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND="sys-libs/readline"
RDEPEND="${DEPEND}"

src_compile() {
	echo $(tc-getCXX) ${CXXFLAGS} ${LDFLAGS} -o gnaw gnaw.cpp -lm -lreadline -lhistory
	$(tc-getCXX) ${CXXFLAGS} ${LDFLAGS} -o gnaw gnaw.cpp -lm -lreadline -lhistory || die
}

src_install() {
	dobin gnaw
	gzip -d gnaw.1.gz
	doman gnaw.1
	dodoc {changelog,readme}.txt
}
