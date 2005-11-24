# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2

MY_P="${P}-u4-b4"
DESCRIPTION="Monkey's Audio, non-win32 platform port"
HOMEPAGE="http://sourceforge.net/projects/mac-port"
SRC_URI="mirror://sourceforge/mac-port/${MY_P}.tar.gz"

KEYWORDS="~x86"
SLOT="0"
IUSE="static"
LICENSE="GPL-2 LGPL-2.1"

DEPEND="x86? ( dev-lang/nasm )"

S="${WORKDIR}/${MY_P}"

src_compile() {
	use static || sed -i 's:-all-static:#-all-static:' src/Console/Makefile.in
	econf `use_enable static` `use_enable !static shared` || die
	emake || die
}

src_install() {
	einstall || die
	dodoc AUTHORS COPYING ChangeLog NEWS README src/*.txt
}
