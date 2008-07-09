# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

MY_PV="${PN}${PV}"
DESCRIPTION="tktray - System Tray Icon Support for Tk on X11"
HOMEPAGE="http://sw4me.com/wiki/Tktray"
SRC_URI="http://www.sw4me.com/${MY_PV}.tar.gz"
S="${WORKDIR}/${MY_PV}"

LICENSE="BWidget"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="threads debug"

DEPEND="
	dev-lang/tk
	x11-libs/libXext
"
RDEPEND="
	${DEPEND}
"

src_compile() {
	econf \
		$(use_enable debug symbols) \
		$(use_enable threads) \
		|| die
	emake || die
}

src_install() {
	emake DESTDIR=${D} install || die
	dodoc ChangeLog
	dohtml doc/*.html
}
