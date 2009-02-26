# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit subversion autotools

DESCRIPTION="Fbi IMproved is a framebuffer image viewer based on Fbi and inspired from Vim"
HOMEPAGE="http://www.autistici.org/dezperado/fim"
ESVN_REPO_URI="http://code.autistici.org/svn/fim/trunk"
ESVN_PATCHES="${PN}-*.diff"
ESVN_BOOTSTRAP="eautoreconf"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"

IUSE="
debug gif jpeg png tiff postscript screen imagemagick xcf svg xfig dia
readline fbcon aalib libcaca djvu pdf sdl
"

DEPEND="
	gif? ( media-libs/giflib )
	jpeg? ( >=media-libs/jpeg-6b )
	png? ( media-libs/libpng )
	tiff? ( media-libs/tiff )
	postscript? ( app-text/libspectre )
	screen? ( app-misc/screen )
	readline? ( sys-libs/readline )
	aalib? ( media-libs/aalib )
	libcaca? ( media-libs/libcaca )
	djvu? ( app-text/djvu )
	pdf? ( app-text/poppler )
	sdl? ( media-libs/libsdl )
"
RDEPEND="
	${DEPEND}
	imagemagick? ( media-gfx/imagemagick )
	xcf? ( dev-perl/gimp-perl )
	svg? ( media-gfx/inkscape )
	xfig? ( media-gfx/xfig )
	dia? ( app-office/dia )
"
DEPEND="
	${DEPEND}
	sys-devel/flex
	sys-devel/bison
"

src_compile() {
	econf \
		$(use_enable debug) \
		$(use_enable gif) \
		$(use_enable jpeg) \
		$(use_enable png) \
		$(use_enable tiff) \
		$(use_enable screen) \
		$(use_enable imagemagick convert) \
		$(use_enable xcf xcftopnm) \
		$(use_enable svg inkscape) \
		$(use_enable xfig) \
		$(use_enable dia) \
		$(use_enable fbcon framebuffer) \
		$(use_enable readline) \
		$(use_enable postscript ps) \
		$(use_enable djvu) \
		$(use_enable pdf poppler) \
		$(use_enable pdf) \
		$(use_enable sdl) \
		$(use_enable aalib aa) \
		--enable-fimrc \
		--enable-recursive-dirs \
		--docdir=/usr/share/doc/${PF} \
		|| die "econf failed"

	# parallel make fails
	emake -j1 || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" prefix=/usr install || die "emake install failed"
}
