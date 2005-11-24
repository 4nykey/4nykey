# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

#inherit toolchain-funcs

MY_P="ttaplugin-xmms-${PV}"
DESCRIPTION="TTA input plugin for XMMS"
HOMEPAGE="http://www.true-audio.com"
SRC_URI="mirror://sourceforge/tta/${MY_P}-src.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

S="${WORKDIR}/${MY_P}"
PLUGDIR="`xmms-config --input-plugin-dir`"

DEPEND="media-sound/xmms
		sys-devel/libtool"

src_unpack() {
	unpack ${A}
	sed -i 's:FLAGS=:FLAGS+=:' ${S}/Makefile
#	sed -i \
#	"s:=:+=:; s:^.*-O:\t`tc-getCC`:; s:-o \(.*\)\.la:-shared -o \1.so:; s:\.lo:.o:g; s:-rpath :-Wl,-rpath,:" \
#	${S}/Makefile
}

src_install() {
	dodoc Readme
	dodir ${PLUGDIR}
	libtool --mode=install install libxmms-tta.la ${D}${PLUGDIR}
#	into `xmms-config --input-plugin-dir`
#	dolib.so *.so
}
