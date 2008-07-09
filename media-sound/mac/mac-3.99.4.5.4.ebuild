# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

inherit eutils versionator

MY_PV="$(get_version_component_range 1-2)"
MY_PV+="-u$(get_version_component_range 3)"
MY_PV+="-b$(get_version_component_range 4)"
MY_PV1="s$(get_version_component_range 5)"
MY_P="${PN}-${MY_PV}-${MY_PV1}"
DESCRIPTION="Monkey's Audio, non-win32 platform port"
HOMEPAGE="http://www.monkeysaudio.com http://supermmx.org/linux/mac"
SRC_URI="
	http://etree.org/shnutils/shntool/support/formats/ape/unix/${MY_PV}/${MY_PV1}/${MY_P}.tar.gz
"
S="${WORKDIR}/${MY_P}"

KEYWORDS="~x86 ~amd64"
SLOT="0"
IUSE=""
LICENSE="MAC"

DEPEND="
	x86? ( dev-lang/yasm )
"

src_compile() {
	sed -i 's:-O3:-DSHNTOOL:' configure
	econf \
		--disable-dependency-tracking \
		--enable-assembly \
		|| die
	emake || die
}

src_install() {
	einstall || die
	dodoc AUTHORS COPYING ChangeLog* NEWS README TODO src/*.txt
	dohtml src/*.htm
}
