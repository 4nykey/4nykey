# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit subversion

DESCRIPTION="The Theora Video Compression Codec (experimental version)"
HOMEPAGE="http://www.theora.org/"
ESVN_REPO_URI="http://svn.xiph.org/experimental/derf/theora-exp"
ESVN_PATCHES="autog_skipconf.diff"
ESVN_BOOTSTRAP="./autogen.sh"

LICENSE="xiph"
SLOT="0"
KEYWORDS="~x86"
IUSE="static"

DEPEND=">=media-libs/libogg-1.1.0
	>=media-libs/libvorbis-1.0.1
	>=sys-devel/automake-1.6"

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
