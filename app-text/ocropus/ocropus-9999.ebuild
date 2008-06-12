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
IUSE="spell lua readline sdl verbose-build"

RDEPEND="
	app-text/tesseract-ocr
	media-libs/libpng
	media-libs/jpeg
	media-libs/tiff
	spell? (
		app-text/aspell
		app-dicts/aspell-en
	)
	lua? ( dev-lang/lua )
	readline? ( sys-libs/readline )
	sdl? (
		media-libs/sdl-gfx
		media-libs/sdl-image
	)
"
DEPEND="
	${RDEPEND}
	dev-util/ftjam
"

src_compile() {
	econf \
		--with-tesseract=/usr \
		$(use_with spell aspell) \
		$(use_with lua ocroscript) \
		$(use_with sdl SDL) \
		|| die "econf failed"

	use verbose-build && MAKEOPTS+=" -dx"
	jam -q ${MAKEOPTS} \
		-sopt="$CXXFLAGS" \
		|| die "jam build failed"
}

src_install() {
	jam -q ${MAKEOPTS} \
		-sDESTDIR="${D}" \
		install \
		|| die "jam install failed"
	dodoc CHANGES INSTALL README
}
