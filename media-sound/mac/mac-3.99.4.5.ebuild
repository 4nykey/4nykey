# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

inherit eutils versionator

MY_P="${PN}-$(get_version_component_range 1-2)"
MY_P="${MY_P}-u$(get_version_component_range 3)"
MY_P="${MY_P}-b$(get_version_component_range 4)"
DESCRIPTION="Monkey's Audio, non-win32 platform port"
HOMEPAGE="http://www.monkeysaudio.com http://supermmx.org/linux/mac"
SRC_URI="
	http://supermmx.org/download/linux/mac/${MY_P}.tar.gz
	http://jserv.sayya.org/multimedia/${MY_P}.tar.gz
	http://ptao.victim.free.fr/DL/${MY_P}.tar.gz
	http://www.etree.org/shnutils/shntool/support/formats/ape/unix/${MY_P}-shntool.patch
"
S="${WORKDIR}/${MY_P}"

KEYWORDS="~x86"
SLOT="0"
IUSE=""
LICENSE="MAC"

DEPEND="
	x86? ( dev-lang/yasm )
"

src_unpack() {
	unpack ${MY_P}.tar.gz
	cd ${S}
	epatch "${DISTDIR}"/${MY_P}-shntool.patch
	sed -i 's:-O3:-DSHNTOOL:' configure
}

src_install() {
	einstall || die
	dodoc AUTHORS COPYING ChangeLog NEWS README TODO src/*.txt
	dohtml src/*.htm
}
