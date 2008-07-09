# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/dvdauthor/dvdauthor-0.6.11.ebuild,v 1.6 2006/01/28 18:06:49 dertobi123 Exp $

inherit eutils darcs autotools

DESCRIPTION="Tools for generating DVD files to be played on standalone DVD players"
HOMEPAGE="http://dvdauthor.sourceforge.net/"
EDARCS_REPOSITORY="http://dvdauthor.sourceforge.net/darcs"
EDARCS_LOCALREPO="${PN}"
WANT_AUTOMAKE="1.9"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="doc truetype bidi"

RDEPEND="
	media-libs/libdvdread
	>=media-gfx/imagemagick-5.5.7
	>=dev-libs/libxml2-2.6
	media-libs/libpng
	truetype? ( >=media-libs/freetype-2 )
	bidi? ( dev-libs/fribidi )
"
DEPEND="
	${RDEPEND}
	sys-devel/gettext
	doc? ( app-text/docbook-sgml-utils )
"

src_unpack() {
	darcs_src_unpack
	cd ${S}
	use doc || sed -i Makefile.am -e 's:\(SUBDIRS.*\)doc :\1:'
	epatch ${FILESDIR}/${PN}-*.diff
	eautoreconf
}

src_compile(){
	econf || die
	use doc && emake -C doc manpages html || die
	emake -C src || die
}

src_install() {
	make install DESTDIR="${D}" || die "installation failed"
	use doc && dohtml -r doc/
	dodoc ChangeLog README TODO
}
