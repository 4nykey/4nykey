# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-client/dillo/dillo-0.8.6.ebuild,v 1.1 2006/09/10 23:08:04 exg Exp $

EAPI="2"

inherit cvs autotools

DESCRIPTION="Lean FLTK-based web browser"
HOMEPAGE="http://www.dillo.org/"
ECVS_SERVER="auriga.wearlab.de:/sfhome/cvs/dillo"
ECVS_MODULE="dillo2"
S="${WORKDIR}/${ECVS_MODULE}"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="ipv6 png jpeg gif ssl +doublebuffer"

RDEPEND="
	x11-libs/fltk:2[threads]
	jpeg? ( media-libs/jpeg )
	png? ( media-libs/libpng )
	ssl? ( dev-libs/openssl )
"
DEPEND="
	${RDEPEND}
	dev-lang/perl
"

src_unpack() {
	cvs_src_unpack
	cd ${S}
	eautoreconf
}

src_compile() {
	econf \
		$(use_enable ipv6) \
		$(use_enable png) \
		$(use_enable jpeg) \
		$(use_enable gif) \
		$(use_enable ssl) \
		$(use_enable doublebuffer) \
		|| die
	emake || die
}

src_install() {
	emake DESTDIR=${D} install || die

	dodoc AUTHORS COPYING ChangeLog* README* NEWS
	docinto doc
	dodoc doc/*.txt doc/README
}
