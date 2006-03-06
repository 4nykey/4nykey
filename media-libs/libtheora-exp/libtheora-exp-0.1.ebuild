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
IUSE="static"

DEPEND=">=media-libs/libogg-1.1.0
	>=media-libs/libvorbis-1.0.1"

src_unpack() {
	subversion_src_unpack
	cd ${S}
	eautoreconf || die
}

src_compile() {
	econf \
		$(use_enable x86 x86asm) \
		$(use_enable static) || die
	emake || die
}

src_install() {
	einstall docdir=${D}/usr/share/doc/${PF} || die
	dodoc README
}
