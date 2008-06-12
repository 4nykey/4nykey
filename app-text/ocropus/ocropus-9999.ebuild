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
IUSE="fst spell readline sdl leptonica verbose-build"

RDEPEND="
	app-text/tesseract-ocr
	media-libs/libpng
	media-libs/jpeg
	media-libs/tiff
	fst? ( dev-libs/libfst )
	spell? (
		app-text/aspell
		app-dicts/aspell-en
	)
	readline? ( sys-libs/readline )
	sdl? (
		media-libs/sdl-gfx
		media-libs/sdl-image
	)
	leptonica? ( media-libs/leptonlib )
"
DEPEND="
	${RDEPEND}
	dev-util/ftjam
"

src_compile() {
	if use leptonica && built_with_use 'media-libs/leptonlib' gif; then
		local _libs="-lgif"
	fi

	LIBS="${_libs}" \
	econf \
		--with-tesseract=/usr \
		--with-ocroscript \
		$(use_with fst) \
		$(use_with spell aspell) \
		$(use_with sdl SDL) \
		$(use_with leptonica) \
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
