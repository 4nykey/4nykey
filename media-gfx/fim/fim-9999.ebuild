# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools
if [[ ${PV} = *9999* ]]; then
	inherit subversion
	ESVN_REPO_URI="https://svn.savannah.nongnu.org/svn/fbi-improved/trunk"
	KEYWORDS=""
else
	MY_P="${P/_pre*/-trunk}"
	MY_P="${MY_P/_/-}"
	SRC_URI="mirror://nongnu/fbi-improved/${MY_P}.tar.bz2 -> ${P}.tar.bz2"
	RESTRICT="primaryuri"
	KEYWORDS="~x86 ~amd64"
	S="${WORKDIR}/${MY_P}"
fi

DESCRIPTION="Fbi IMproved is a framebuffer image viewer"
HOMEPAGE="http://www.nongnu.org/fbi-improved"

LICENSE="GPL-2"
SLOT="0"
IUSE="
aalib archive debug dia djvu exif fbcon gif graphicsmagick imagemagick imlib
jpeg jpeg2k pdf png postscript readline +screen sdl svg tiff truetype xfig
"

PATCHES=(
	"${FILESDIR}"/${PN}-poppler.diff
	"${FILESDIR}"/${PN}-string.diff
)

DEPEND="
	graphicsmagick? ( media-gfx/graphicsmagick )
	imlib? ( media-libs/imlib2 )
	gif? ( media-libs/giflib )
	tiff? ( media-libs/tiff:0 )
	readline? ( sys-libs/readline:0 )
	jpeg? ( virtual/jpeg:62 )
	jpeg2k? ( media-libs/jasper )
	postscript? ( app-text/libspectre )
	djvu? ( app-text/djvu )
	pdf? ( app-text/poppler[cairo] )
	png? ( media-libs/libpng:0 )
	exif? ( media-libs/libexif )
	aalib? ( media-libs/aalib )
	sdl? ( media-libs/libsdl )
	archive? ( app-arch/libarchive )
	truetype? ( media-libs/freetype:2 )
"
RDEPEND="
	${DEPEND}
	imagemagick? ( media-gfx/imagemagick )
	svg? ( media-gfx/inkscape )
	xfig? ( media-gfx/xfig )
	dia? ( app-office/dia )
	screen? ( app-misc/screen )
	media-fonts/terminus-font
"
DEPEND="
	${DEPEND}
	sys-devel/flex
	virtual/yacc
"
DOCS=( doc/FIM.TXT )

src_prepare() {
	default
	sed \
		-e "s:esyscmd.*:${ESVN_WC_REVISION:--1}):" \
		-e '/LIBS/s:GraphicsMagick.*`:pkg-config GraphicsMagick --libs`:' \
		-e '/CXXFLAGS/s:GraphicsMagick.*`:pkg-config GraphicsMagick --cflags`:'\
		-e 's:imlib2-config --libs.*`:pkg-config imlib2 x11 --libs`:' \
		-e '/LIBSDL_CONFIG_FLAGS=/s:static-::' \
		-i configure.ac
	sed \
		-e '/SUBDIRS = /s:\<doc\>::' \
		-i Makefile.am
	eautoreconf
}

src_configure() {
	local myeconfargs=(
		$(use_enable graphicsmagick)
		$(use_enable imlib imlib2)
		$(use_enable fbcon framebuffer)
		$(use_enable gif)
		$(use_enable tiff)
		$(use_enable readline)
		$(use_enable jpeg)
		$(use_enable jpeg2k jasper)
		$(use_enable postscript ps)
		$(use_enable djvu)
		$(use_enable pdf)
		$(use_enable pdf poppler)
		$(use_enable png)
		$(use_enable archive)
		$(use_enable exif)
		$(use_enable aalib aa)
		$(use_enable sdl)
		$(use_enable imagemagick convert)
		$(use_enable svg inkscape)
		$(use_enable xfig)
		$(use_enable dia)
		$(use_enable truetype unicode)
		$(use_enable debug)
		$(use_enable screen)
		--disable-option-checking
		--docdir=/usr/share/doc/${PF}
		--with-default-consolefont=/usr/share/consolefonts/ter-114n.psf.gz
		--disable-hardcoded-font
		--disable-matrices-rendering
		--enable-fimrc
		--enable-history
		--enable-loader-string-specification
		--enable-mark-and-dump
		--enable-output-console
		--enable-raw-bits-rendering
		--enable-read-dirs
		--enable-recursive-dirs
		--enable-resize-optimizations
		--enable-scan-consolefonts
		--enable-scripting
		--enable-seek-magic
		--enable-stdin-image-reading
		--enable-windows
		--enable-custom-status-bar
	)
	econf "${myeconfargs[@]}"
}
