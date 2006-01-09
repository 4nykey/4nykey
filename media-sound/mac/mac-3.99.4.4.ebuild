# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

inherit eutils versionator

MY_P="${PN}-$(get_version_component_range 1-2)"
MY_P="${MY_P}-u$(get_version_component_range 3)"
MY_P="${MY_P}-b$(get_version_component_range 4)"
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
	sed -i 's:-s -O3 ::' configure
	econf --enable-backward `use_enable static` || die
	emake || die
}

src_install() {
	einstall || die
	dodoc AUTHORS COPYING ChangeLog NEWS README TODO src/*.txt
	dohtml src/*.htm
}
