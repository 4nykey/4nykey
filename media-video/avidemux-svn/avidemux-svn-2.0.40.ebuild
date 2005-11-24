# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/avidemux/avidemux-2.0.38_rc2-r1.ebuild,v 1.1 2005/04/18 15:44:32 flameeyes Exp $

inherit subversion eutils flag-o-matic

PATCHLEVEL=7
DESCRIPTION="Great Video editing/encoding tool"
HOMEPAGE="http://fixounet.free.fr/avidemux/"
SRC_URI="http://digilander.libero.it/dgp85/gentoo/${PN/-svn}-patches-${PATCHLEVEL}.tar.bz2"
ESVN_REPO_URI="svn://svn.berlios.de/avidemux/trunk/avidemux"

LICENSE="GPL-2"
SLOT="2"
KEYWORDS="~x86 ~ppc ~amd64"
IUSE="a52 aac alsa altivec arts encode mad mmx nls vorbis sdl truetype xvid xv oss x264"

RDEPEND="xv? ( virtual/x11 )
	a52? ( >=media-libs/a52dec-0.7.4 )
	encode? ( >=media-sound/lame-3.93 )
	>=dev-libs/libxml2-2.6.7
	>=x11-libs/gtk+-2.4.1
	aac? ( >=media-libs/faac-1.23.5
	       >=media-libs/faad2-2.0-r2 )
	mad? ( media-libs/libmad )
	xvid? ( >=media-libs/xvid-1.0.0 )
	x86? ( dev-lang/nasm )
	nls? ( >=sys-devel/gettext-0.12.1 )
	vorbis? ( >=media-libs/libvorbis-1.0.1 )
	arts? ( >=kde-base/arts-1.2.3 )
	truetype? ( >=media-libs/freetype-2.1.5 )
	alsa? ( >=media-libs/alsa-lib-1.0.3b-r2 )
	x264? ( media-libs/x264 )
	sdl? ( media-libs/libsdl )"

DEPEND="$RDEPEND
	dev-util/pkgconfig
	>=sys-devel/autoconf-2.58
	>=sys-devel/automake-1.8.3"

filter-flags "-fno-default-inline"
filter-flags "-funroll-loops"
filter-flags "-funroll-all-loops"
filter-flags "-fforce-addr"

src_unpack() {
	subversion_src_unpack
	cd ${WORKDIR}
	unpack ${A}
	cd ${S} || die

	epatch ${WORKDIR}/${PVR}/patches/0{0,1}_*.patch

	cp ${WORKDIR}/${PVR}/m4/* ${S}/m4 || die "cp m4 failed"

	sed -i 's:head -:head -n :g; s:ACLOCAL >:ACLOCAL 2>:g' admin/cvs.sh
	has_version '>=media-libs/faad2-2.1' && \
		sed -i 's:faacDecInit:NeAACDecInit:' configure.in.in

	WANT_AUTOMAKE=1.7 \
		make -f Makefile.dist || die "autotools failed."
}

src_compile() {
	local myconf
	use mmx || myconf="${myconf} --disable-mmx"
	econf \
		$(use_enable nls) \
		$(use_enable altivec) \
		$(use_enable xv) \
		$(use_with mad libmad) \
		$(use_with arts) \
		$(use_with alsa) \
		$(use_with oss) \
		$(use_with vorbis) \
		$(use_with a52 a52dec) \
		$(use_with sdl libsdl) \
		$(use_with truetype freetype2) \
		$(use_with aac faac) $(use_with aac faad2) --with-newfaad \
		$(use_with xvid) \
		$(use_with encode lame) \
		--disable-warnings --disable-dependency-tracking \
		${myconf} || die "configure failed"
	make || die "make failed"
}

src_install() {
	make DESTDIR=${D} install || die "make install failed"
	dodoc AUTHORS ChangeLog History README TODO
}

pkg_postinst() {
	if use ppc && use oss; then
		echo
		einfo "OSS sound output may not work on ppc"
		einfo "If your hear only static noise, try"
		einfo "changing the sound device to ALSA or arts"
	fi
}

