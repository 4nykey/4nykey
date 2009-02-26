# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-client/dillo/dillo-0.8.6.ebuild,v 1.1 2006/09/10 23:08:04 exg Exp $

EAPI="2"

inherit mercurial autotools savedconfig

DESCRIPTION="Lean FLTK-based web browser"
HOMEPAGE="http://www.dillo.org/"
EHG_REPO_URI="http://hg.dillo.org/dillo"
S="${WORKDIR}/${EHG_REPO_URI##*/}"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="ipv6 png jpeg gif ssl"

RDEPEND="
	x11-libs/fltk:2[threads,-cairo,jpeg=,png=]
	jpeg? ( media-libs/jpeg )
	png? ( media-libs/libpng )
	ssl? ( dev-libs/openssl )
"
DEPEND="
	${RDEPEND}
	dev-lang/perl
"

src_unpack() {
	mercurial_src_unpack
	cd ${S}
	restore_config src/pixmaps.h
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable ipv6) \
		$(use_enable png) \
		$(use_enable jpeg) \
		$(use_enable gif) \
		$(use_enable ssl) \
		|| die
}

src_install() {
	emake DESTDIR=${D} install || die

	dodoc AUTHORS COPYING ChangeLog* README* NEWS
	docinto doc
	dodoc doc/*.txt doc/README
	save_config src/pixmaps.h
}

pkg_postinst() {
	elog "To use alternative toolbar iconset, save one of the
\`pixmaps.xxx.h' available at http://www.dillo.org/Icons
as /etc/portage/savedconfig/${CATEGORY}/${PF}
and remerge with USE=savedconfig"
}
