# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

inherit subversion autotools-utils

DESCRIPTION="Fbi IMproved is a framebuffer image viewer based on Fbi and inspired from Vim"
HOMEPAGE="http://www.autistici.org/dezperado/fim"
ESVN_REPO_URI="http://code.autistici.org/svn/fim/trunk"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="
graphicsmagick imlib fbcon gif tiff readline jpeg postscript djvu pdf png exif
aalib sdl xcf svg xfig dia debug screen
"

AUTOTOOLS_AUTORECONF="1"
AUTOTOOLS_IN_SOURCE_BUILD="1"
PATCHES=("${FILESDIR}"/${PN}*.diff)

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
"
RDEPEND="
	${DEPEND}
	xcf? ( dev-perl/gimp-perl )
	svg? ( media-gfx/inkscape )
	xfig? ( media-gfx/xfig )
	dia? ( app-office/dia )
	screen? ( app-misc/screen )
"
DEPEND="
	${DEPEND}
	sys-devel/flex
	sys-devel/bison
"

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
		$(use_enable exif)
		$(use_enable aalib aa)
		$(use_enable sdl)
		$(use_enable xcf xcftopnm)
		$(use_enable svg inkscape)
		$(use_enable xfig)
		$(use_enable dia)
		$(use_enable debug)
		$(use_enable screen)
		--enable-fimrc
		--enable-recursive-dirs
		--enable-unicode
		--enable-hardcoded-font
		--docdir=/usr/share/doc/${PF}
	)
	autotools-utils_src_configure
}
