# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EANT_BUILD_TARGET="dist"

inherit java-pkg-2 java-ant-2

MY_P="${P}-src"
DESCRIPTION="A dictionary application, supporting various dictionary formats"
HOMEPAGE="http://jalingo.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.7z"
S="${WORKDIR}/${MY_P}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND=">=virtual/jdk-1.5"
RDEPEND=">=virtual/jre-1.5"

src_install() {
	java-pkg_dojar dist/${PN}.jar
	java-pkg_dolauncher ${PN}
	doicon src.setup/resources/
	make_desktop_entry ${PN} JaLingo ${PN}64x64.png
}

