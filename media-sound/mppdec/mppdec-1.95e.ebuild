# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="Musepack SV7 decoder"
HOMEPAGE="http://www.musepack.net"
SRC_URI="http://4nykey.googlecode.com/files/${P}.zip"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="esd"

RDEPEND="
	esd? ( media-sound/esound )
"
DEPEND="
	${RDEPEND}
	x86? ( dev-lang/nasm )
"

src_unpack() {
	unpack ${A}
	cd ${S}
	use esd || sed -e '/\(USE_ESD_AUDIO\|-lesd\)/d' -i mpp.h Makefile
	use amd64 && sed -e '/\(USE_ASM\|^MPPDEC_ASO =\)/d' -i mpp.h Makefile
	epatch "${FILESDIR}"/${PN}*.diff
}

src_compile() {
	emake CFLAGS="${CFLAGS}" config.h || die
	emake \
		CC=$(tc-getCC) STRIP=true \
		CFLAGS="${CFLAGS} -DMPP_DECODER -DCD_SAMPLE_FREQ=44100" \
		OPTIM_SIZE= \
		mppdec replaygain \
		|| die
}

src_install() {
	dobin mppdec replaygain
	dodoc readme
}
