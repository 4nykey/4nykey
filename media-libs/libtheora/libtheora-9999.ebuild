# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit subversion autotools

AT_M4DIR="m4"
DESCRIPTION="The Theora Video Compression Codec"
HOMEPAGE="http://www.theora.org/"
ESVN_REPO_URI="http://svn.xiph.org/trunk/theora"
ESVN_BOOTSTRAP="eautoreconf"

LICENSE="xiph"
SLOT="0"
KEYWORDS="~x86"
IUSE="encode mmx static player"

RDEPEND="
	>=media-libs/libogg-1.1.0
	>=media-libs/libvorbis-1.0.1
	player? ( media-libs/libsdl )
"
DEPEND="
	${RDEPEND}
	player? ( virtual/os-headers )
"

src_unpack() {
	subversion_src_unpack
	cd ${S}
#	AT_M4DIR="${S}/m4" eautoreconf || die
}

src_compile() {
	econf \
		$(use_enable static) \
		$(use_enable mmx asm) \
		$(use_enable encode) || die
	emake || die
}

src_install() {
	einstall docdir=${D}/usr/share/doc/${PF} || die
	dodoc AUTHORS CHANGES README
}
