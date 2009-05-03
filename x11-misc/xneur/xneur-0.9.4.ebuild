# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="X Neural Switcher is an automatic keyboard layout switcher"
HOMEPAGE="http://xneur.ru"
SRC_URI="http://dists.xneur.ru/release-${PV}/tgz/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="gstreamer openal alsa debug pcre spell xosd"

DEPEND="
	gstreamer? ( media-libs/gstreamer )
	openal? ( media-libs/freealut )
	pcre? ( dev-libs/libpcre )
	xosd? ( x11-libs/xosd )
	x11-libs/libX11
"
RDEPEND="
	${DEPEND}
	alsa? ( media-sound/alsa-utils )
"
DEPEND="
	${DEPEND}
	dev-util/pkgconfig
"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${P}*.diff
}

src_compile() {
	local myconf
	if use alsa; then
		myconf="--with-sound=aplay"
	elif use gstreamer; then
		myconf="--with-sound=gstreamer"
	elif use openal; then
		myconf="--with-sound=openal"
	else
		myconf="--without-sound"
	fi

	econf \
		$(use_with debug) \
		$(use_with pcre) \
		$(use_with spell aspell) \
		$(use_with xosd) \
		${myconf} \
		|| die

	emake || die
}

src_install () {
	emake DESTDIR="${D}" install || die
	dodoc AUTHORS ChangeLog NEWS README TODO
}
