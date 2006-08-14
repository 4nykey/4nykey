# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/freqtweak/freqtweak-0.6.0-r1.ebuild,v 1.1 2005/04/25 16:50:52 luckyduck Exp $

inherit wxwidgets flag-o-matic

RESTRICT="nomirror"
DESCRIPTION="FFT-based realtime audio spectral manipulation and display"
HOMEPAGE="http://freqtweak.sourceforge.net http://essej.net/freqtweak"
SRC_URI="http://essej.net/freqtweak/freqtweak-0.7.0dev.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="unicode"

DEPEND=">=x11-libs/wxGTK-2.4
	>=sci-libs/fftw-3.0
	=dev-libs/libsigc++-1.2*
	dev-libs/libxml2
	media-sound/jack-audio-connection-kit"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${A/.tar*/}"

src_unpack() {
	if has_version '>=x11-libs/wxGTK-2.6'; then
		WX_GTK_VER=2.6
	fi
	if use unicode; then
		need-wxwidgets unicode
	elif has_version '>=x11-libs/gtk+-2'; then
		need-wxwidgets gtk2
	else
		need-wxwidgets gtk
	fi
	unpack ${A}
	sed -i 's:\(EXTRA_OPT_CFLAGS="\).*:\1":' ${S}/configure
	append-flags -fno-strict-aliasing
}

src_install() {
	make DESTDIR="${D}" install || die "make install failed"
	dodoc AUTHORS ChangeLog NEWS README THANKS
}
