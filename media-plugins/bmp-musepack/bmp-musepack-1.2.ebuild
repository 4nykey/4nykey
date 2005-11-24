# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/bmp-musepack/bmp-musepack-1.1.2.ebuild,v 1.2 2005/02/06 02:01:16 luckyduck Exp $

IUSE=""

MY_P="${P/_rc/-RC}"
DESCRIPTION="Musepack input plugin for Beep Media Player"
HOMEPAGE="http://www.musepack.net"
SRC_URI="http://musepack.origean.net/files/linux/plugins/${MY_P}.tar.bz2"
S="${WORKDIR}/${MY_P}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~x86"

DEPEND=">=media-sound/beep-media-player-0.9.0
	media-libs/taglib
	media-libs/libmpcdec"

src_install() {
	make DESTDIR="${D}" install
}
