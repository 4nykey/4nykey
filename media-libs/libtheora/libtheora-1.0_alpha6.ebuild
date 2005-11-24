# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit subversion

DESCRIPTION="The Theora Video Compression Codec"
HOMEPAGE="http://www.theora.org/"
#SRC_URI="http://www.theora.org/files/${P/_}.tar.bz2"
ESVN_PATCHES="*.diff"
ESVN_BOOTSTRAP="./autogen.sh"

LICENSE="xiph"
SLOT="0"
KEYWORDS="~x86"
IUSE="encode mmx static liboil"

DEPEND=">=media-libs/libogg-1.1.0
	>=media-libs/libvorbis-1.0.1
	liboil? ( dev-libs/liboil )
	>=sys-devel/automake-1.6"

S=${WORKDIR}/${P/_}

pkg_setup() {
	if use mmx; then
		einfo "Using theora-mmx branch"
		ESVN_REPO_URI="http://svn.xiph.org/branches/theora-mmx"
	elif use liboil; then
		einfo "Using theora-oil branch"
		ESVN_REPO_URI="http://svn.xiph.org/branches/theora-oil"
	else
		ESVN_REPO_URI="http://svn.xiph.org/trunk/theora"
	fi
}

src_compile() {
	econf \
		$(use_enable static) \
		$(use_enable encode) || die
	emake || die
}

src_install() {
	einstall docdir=${D}/usr/share/doc/${PF} || die
	dodoc README
}
