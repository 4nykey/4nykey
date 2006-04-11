# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit subversion autotools

DESCRIPTION="The Theora Video Compression Codec (experimental version)"
HOMEPAGE="http://www.theora.org/"
ESVN_REPO_URI="http://svn.xiph.org/experimental/derf/theora-exp"

LICENSE="xiph"
SLOT="0"
KEYWORDS="~x86"
IUSE="static encode sdl"

DEPEND=">=media-libs/libvorbis-1.0.1
	sdl? ( media-libs/libsdl )"

src_unpack() {
	subversion_src_unpack
	cd ${S}
	AT_M4DIR="${S}/m4"
	eautoreconf || die
}

src_compile() {
	econf \
		$(use_enable encode) \
		$(use_enable x86 x86asm) \
		$(use_enable static) || die
	emake || die
}

src_install() {
	einstall docdir=${D}/usr/share/doc/${PF} || die
	dodoc README
}
