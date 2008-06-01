# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit subversion

DESCRIPTION="OCRopus is a state-of-the-art document analysis and OCR system"
HOMEPAGE="http://www.ocropus.org"
ESVN_REPO_URI="http://ocropus.googlecode.com/svn/trunk"
ESVN_PATCHES="${PN}-*.diff"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

RDEPEND="
	app-text/tesseract-ocr
	app-text/aspell
	media-libs/libpng
	media-libs/jpeg
	media-libs/tiff
"
DEPEND="
	${RDEPEND}
	dev-util/ftjam
"

src_compile() {
	econf \
		--with-tesseract=/usr \
		|| die "econf failed"
	jam ${MAKEOPTS} \
		-q -dx \
		-sopt="$CXXFLAGS" \
		|| die "jam build failed"
}

src_install() {
	jam -q -dx \
		-sDESTDIR="${D}" \
		install \
		|| die "jam install failed"
	dodoc CHANGES README
}
