# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/freqtweak/freqtweak-0.6.0-r1.ebuild,v 1.1 2005/04/25 16:50:52 luckyduck Exp $

inherit wxwidgets-nu flag-o-matic

MY_P="${P}dev"
DESCRIPTION="FFT-based realtime audio spectral manipulation and display"
HOMEPAGE="http://freqtweak.sourceforge.net http://essej.net/freqtweak"
SRC_URI="http://essej.net/freqtweak/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"
RESTRICT="primaryuri"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="unicode fftw"

DEPEND="
	fftw? ( >=sci-libs/fftw-3.0 )
	>=x11-libs/wxGTK-2.6
	=dev-libs/libsigc++-1.2*
	dev-libs/libxml2
	media-sound/jack-audio-connection-kit
"
RDEPEND="
	${DEPEND}
"

src_unpack() {
	WX_GTK_VER=2.6
	if use unicode; then
		need-wxwidgets unicode
	else
		need-wxwidgets gtk2
	fi
	unpack ${A}
	sed -i 's:\(EXTRA_OPT_CFLAGS="\).*:\1":' ${S}/configure
	append-flags -fno-strict-aliasing
}

src_compile() {
	econf \
		$(use_with fftw fftw3) \
		--with-wxconfig-path="${WX_CONFIG}" \
		|| die
	emake || die
}

src_install() {
	make DESTDIR="${D}" install || die "make install failed"
	dodoc AUTHORS ChangeLog NEWS README THANKS
}
