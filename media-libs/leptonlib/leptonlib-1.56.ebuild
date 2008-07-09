# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="Leptonica image processing and analysis library"
HOMEPAGE="http://www.leptonica.com/"
SRC_URI="http://www.leptonica.com/source/${P}.tar.gz"

LICENSE="CCPL-Attribution-2.0"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="png jpeg gif tiff"

DEPEND="
	png? ( media-libs/libpng )
	jpeg? ( media-libs/jpeg )
	gif? ( media-libs/giflib )
	tiff? ( media-libs/tiff )
"
RDEPEND="
	${DEPEND}
"

src_compile() {
	econf || die
	emake CFLAGS="${CFLAGS}" || die
}

src_install() {
	einstall || die
	dohtml *.{html,jpg}
}
