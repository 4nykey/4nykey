# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit autotools-utils
if [[ ${PV} = *9999* ]]; then
	inherit subversion
	ESVN_REPO_URI="http://code.autistici.org/svn/fim/trunk"
	ESVN_OFFLINE="1"
	SRC_URI="mirror://nongnu/fbi-improved/fim.svndump.gz"
	KEYWORDS=""
else
	MY_P="${P/_/-}"
	SRC_URI="mirror://nongnu/fbi-improved/${MY_P}.tar.bz2"
	KEYWORDS="~x86 ~amd64"
	S="${WORKDIR}/${MY_P}"
fi

DESCRIPTION="Fbi IMproved is a framebuffer image viewer based on Fbi and inspired from Vim"
HOMEPAGE="http://www.autistici.org/dezperado/fim"
RESTRICT="primaryuri"

LICENSE="GPL-2"
SLOT="0"
IUSE="
aalib archive debug dia djvu exif fbcon gif graphicsmagick imagemagick imlib
jpeg pdf png postscript -raw readline +screen sdl svg tiff truetype xcf xfig
"

AUTOTOOLS_AUTORECONF="1"
AUTOTOOLS_IN_SOURCE_BUILD="1"
PATCHES=( "${FILESDIR}"/${PN}*.diff )

DEPEND="
	graphicsmagick? ( media-gfx/graphicsmagick )
	imlib? ( media-libs/imlib2 )
	gif? ( media-libs/giflib )
	tiff? ( media-libs/tiff )
	readline? ( sys-libs/readline )
	jpeg? ( virtual/jpeg )
	postscript? ( app-text/libspectre )
	djvu? ( app-text/djvu )
	pdf? ( app-text/poppler[cairo] )
	png? ( media-libs/libpng )
	exif? ( media-libs/libexif )
	aalib? ( media-libs/aalib )
	sdl? ( media-libs/libsdl )
	raw? ( media-gfx/ufraw )
	archive? ( app-arch/libarchive )
	truetype? ( media-libs/freetype:2 )
"
RDEPEND="
	${DEPEND}
	imagemagick? ( media-gfx/imagemagick )
	xcf? ( dev-perl/gimp-perl )
	svg? ( media-gfx/inkscape )
	xfig? ( media-gfx/xfig )
	dia? ( app-office/dia )
	screen? ( app-misc/screen )
	media-fonts/terminus-font
"
DEPEND="
	${DEPEND}
	sys-devel/flex
	sys-devel/bison
"

src_prepare() {
	sed \
		-e "s:esyscmd.*:${ESVN_WC_REVISION:--1}):" \
		-e '/LIBS/s:GraphicsMagick.*`:pkg-config GraphicsMagick --libs`:' \
		-e '/CXXFLAGS/s:GraphicsMagick.*`:pkg-config GraphicsMagick --cflags`:'\
		-e 's:imlib2-config --libs.*`:pkg-config imlib2 x11 --libs`:' \
		-i configure.ac
	sed \
		-e 's:htmldir = \$(docdir)$:&/html:' \
		-e 's:\(MAN2HTML=\).*:\1man2html:' \
		-i doc/Makefile.am
	autotools-utils_src_prepare
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
		$(use_enable postscript ps)
		$(use_enable djvu)
		$(use_enable pdf)
		$(use_enable pdf poppler)
		$(use_enable png)
		$(use_enable raw ufraw)
		$(use_enable archive)
		$(use_enable exif)
		$(use_enable aalib aa)
		$(use_enable sdl)
		$(use_enable imagemagick convert)
		$(use_enable xcf xcftopnm)
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
	autotools-utils_src_configure
}
