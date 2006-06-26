# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit wxwidgets

DESCRIPTION="C++ library to create, manipulate and render SVG files"
HOMEPAGE="http://wxsvg.sourceforge.net/"

MY_P="${P/_beta/b}"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz"
LICENSE="wxWinLL-3"
SLOT="0"
KEYWORDS="~x86"

IUSE="debug cairo unicode"

RDEPEND=">=x11-libs/wxGTK-2.4.2
	!cairo? ( media-libs/libart_lgpl )
	cairo? ( x11-libs/cairo )
	media-libs/fontconfig"

DEPEND="${RDEPEND}
	cairo? (dev-util/pkgconfig)"

S="${WORKDIR}/${MY_P}"

src_unpack() {
	unpack ${A}
	has_version '>=x11-libs/wxGTK-2.6' && WX_GTK_VER="2.6"
	if use unicode; then
		need-wxwidgets unicode
	else
		need-wxwidgets gtk2
	fi
	cd "${S}"
	libtoolize --copy --force
}

src_compile() {
	if use cairo; then
		export CPPFLAGS="${CPPFLAGS} $(pkg-config cairo --cflags)"
		myconf="${myconf} --enable-render=cairo"
	fi
	econf \
		$(use_enable debug) \
		--with-wx-config=${WX_CONFIG} \
		${myconf} || die "econf failed"
	emake || die "emake failed"
}

src_install() {
	einstall || die
	dodoc AUTHORS ChangeLog TODO
}
