# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit java-pkg-2

DESCRIPTION="A dictionary application, supporting various dictionary formats"
HOMEPAGE="http://jalingo.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${PN}-setup-${PV}.jar"
S="${WORKDIR}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND="virtual/jre"
RDEPEND="${DEPEND}"

src_unpack() {
	unpack ${A}
	$(java-config-2 -g JAVA_HOME)/bin/unpack200 \
		resources/jalingo.jar.pack.gz jalingo.jar || die
}

src_install() {
	java-pkg_dojar jalingo.jar
	java-pkg_dolauncher ${PN}
	doicon resources/jalingo.png
	make_desktop_entry jalingo JaLingo
}

