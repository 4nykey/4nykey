# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/gnusound/gnusound-0.7.ebuild,v 1.1 2005/04/27 16:55:56 luckyduck Exp $

IUSE="libsamplerate"

inherit gnuconfig eutils

DESCRIPTION="GNUsound is a sound editor for Linux/x86"
HOMEPAGE="http://gnusound.sourceforge.net/"
SRC_URI="ftp://ftp.gnu.org/gnu/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"

RDEPEND="
	>=gnome-base/libglade-2.0.1
	>=gnome-base/libgnomeui-2.2.0.1
	>=media-libs/audiofile-0.2.3
	libsamplerate? ( media-libs/libsamplerate )
"
DEPEND="
	${RDEPEND}
"

src_unpack() {
	unpack ${A} || die "unpack failure"
	cd ${S} || die "workdir not found"
	rm -f doc/Makefile || die "could not remove doc Makefile"
	rm -f modules/Makefile || die "could not remove modules Makefile"
	sed -i "s:docrootdir:datadir:" doc/Makefile.in

	epatch ${FILESDIR}/${P}-destdir.patch

	gnuconfig_update
}

src_compile() {
	ac_cv_header_ffmpeg_avformat_h=no \
	econf \
		$(use_with libsamplerate) \
		--enable-optimization \
		|| die "Configure failure"
	emake || die "Make failure"
}

src_install() {
	make DESTDIR="${D}" install || die "make install failed"
	dodoc README NOTES TODO CHANGES
}
