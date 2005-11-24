# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/xmms-musepack/xmms-musepack-1.1.2.ebuild,v 1.3 2005/05/04 11:43:21 dholm Exp $

IUSE=""

MY_P="${P/_rc/-RC}"
DESCRIPTION="Musepack input plugin for XMMS"
HOMEPAGE="http://www.musepack.net"
SRC_URI="http://musepack.origean.net/files/linux/plugins/${MY_P}.tar.bz2"
S="${WORKDIR}/${MY_P}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~x86"

DEPEND=">=media-sound/xmms-1.2.10
	media-libs/taglib
	media-libs/libmpcdec"

src_install() {
	make DESTDIR="${D}" install || die
	dodoc README
}
