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
IUSE="encode mmx doc"

RDEPEND="
	>=media-libs/libogg-1.1.0
	>=media-libs/libvorbis-1.0.1
"
DEPEND="
	${RDEPEND}
	doc? ( app-doc/doxygen )
"

src_compile() {
	use doc || export ac_cv_prog_HAVE_DOXYGEN="false"
	econf \
		$(use_enable mmx asm) \
		$(use_enable encode) || die
	emake || die
}

src_install() {
	einstall docdir=${D}/usr/share/doc/${PF} || die
	dodoc AUTHORS CHANGES README
}
