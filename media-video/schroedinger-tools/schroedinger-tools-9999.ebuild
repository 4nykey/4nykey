# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/schroedinger/schroedinger-0.9.0.ebuild,v 1.1 2008/01/26 08:35:04 drac Exp $

inherit git autotools

AT_M4DIR="m4"
DESCRIPTION="C-based libraries and GStreamer plugins for the Dirac video codec"
HOMEPAGE="http://schrodinger.sourceforge.net"
EGIT_REPO_URI="git://diracvideo.org/git/schroedinger-tools.git"
EGIT_PATCHES="${PN}-*.diff"
EGIT_BOOTSTRAP="eautoreconf"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

RDEPEND="
	media-libs/schroedinger
	dev-libs/boost
"
DEPEND="
	${RDEPEND}
"

src_install() {
	einstall || die "emake install failed."
	dodoc AUTHORS README USAGE
}
