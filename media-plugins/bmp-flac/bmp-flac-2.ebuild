# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

IUSE=""

DESCRIPTION="FLAC input plugin for Beep Media Player"
HOMEPAGE="http://ccm.sherry.jp/cgi-bin/libroverde/libroverde.cgi/read/2004/4/12"
SRC_URI="http://ryoko.camperquake.de/fedora/bmp-flac/bmp-flac-2-1.src.rpm"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"

RDEPEND=">=media-sound/beep-media-player-0.9.0
	media-libs/flac"
DEPEND="${RDEPEND}
	app-arch/rpm2targz"

src_unpack() {
	cd ${WORKDIR}
	rpm2targz ${DISTDIR}/${A}
	tar xzf bmp-flac-2-1.src.tar.gz
	tar xzf bmp-flac-2.tar.gz
}

src_install() {
	make DESTDIR="${D}" install || die
	dodoc README
}
