# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/fontforge/fontforge-20120731-r1.ebuild,v 1.2 2014/11/16 17:44:50 mgorny Exp $

# Some notes for maintainers this package:
# 1. README-unix: freetype headers are required to make use of truetype debugger
# in fontforge.
# 2. --enable-{double,longdouble} these just make ff use more storage space. In
# normal fonts neither is useful. Leave off.
# 3. FontForge autodetects libraries but does not link with them. They are
# dynamically loaded at run time if fontforge found them at build time.
# --with-regular-link disables this behaviour. No reason to make it optional for
# users. http://fontforge.sourceforge.net/faq.html#libraries. To see what
# libraries fontforge thinks with use $ fontforge --library-status

EAPI=5

PYTHON_COMPAT=( python2_7 )
inherit eutils fdo-mime python-single-r1 git-r3 autotools-utils
if [[ ${PV} == *9999* ]]; then
	EGIT_REPO_URI="git://github.com/${PN}/${PN}.git"
else
	SRC_URI="
		https://codeload.github.com/${PN}/${PN}/tar.gz/${PV} -> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS= #"~amd64 ~x86"
fi

DESCRIPTION="FontForge is a font editor"
HOMEPAGE="http://fontforge.github.io"

LICENSE="BSD GPL-3+"
SLOT="0"
IUSE="cjk cairo gif gtk debug ipython jpeg png +python readline tiff tilepath truetype truetype-debugger svg unicode +X zeromq"

RDEPEND="
	gif? ( >=media-libs/giflib-4.1.0-r1 )
	jpeg? ( virtual/jpeg:0 )
	png? ( >=media-libs/libpng-1.2.4 )
	tiff? ( >=media-libs/tiff-3.5.7-r1 )
	truetype? ( >=media-libs/freetype-2.1.4 )
	truetype-debugger? ( >=media-libs/freetype-2.3.8[fontforge,-bindist] )
	svg? ( >=dev-libs/libxml2-2.6.7 )
	unicode? ( >=media-libs/libuninameslist-030713 )
	cairo? ( >=x11-libs/cairo-1.6.4[X] )
	python? ( ${PYTHON_DEPS} )
	zeromq? ( net-libs/czmq )
	readline? ( sys-libs/readline )
	gtk? ( x11-libs/gtk+:2 )
	ipython? ( dev-python/ipython )
	x11-libs/libXi
	x11-libs/libX11
	x11-proto/inputproto
	!media-gfx/pfaedit
"
DEPEND="
	${RDEPEND}
	sys-devel/gettext
"
AUTOTOOLS_AUTORECONF="1"
AUTOTOOLS_IN_SOURCE_BUILD="1"
DOCS=( doc/README-unix )

REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_unpack() {
	EGIT_REPO_URI="git://git.savannah.gnu.org/gnulib.git" \
	EGIT_CHECKOUT_DIR="${S}/gnulib" \
		git-r3_src_unpack
	EGIT_REPO_URI="https://github.com/troydhanson/uthash" \
	EGIT_CHECKOUT_DIR="${S}/uthash" \
		git-r3_src_unpack
	if [[ ${PV} == *9999* ]]; then
		git-r3_src_unpack
	else
		default
	fi
}

src_prepare() {
	rm -f "${S}"/config.status
	ebegin "Running bootstrap"
	AUTORECONF=true \
		./bootstrap --skip-git --force --gnulib-srcdir="${S}/gnulib" >& \
		"${T}"/bootstrap.log
	eend $? || die "bootstrap failed, check ${T}/bootstrap.log"
	autotools-utils_src_prepare
}

src_configure() {
	local myeconfargs=(
		--disable-static
		$(use_enable truetype-debugger freetype-debugger "/usr/include/freetype2/internal4fontforge/")
		$(use_enable python python-scripting)
		$(use_enable python python-extension)
		$(use_with X x)
		$(use_enable cjk gb12345)
		$(use_enable tilepath tile-path)
		$(use_enable debug)
		$(use_enable debug debug-raw-points)
		$(use_with cairo)
		$(use_enable gtk gtk2-use)
	)
	autotools-utils_src_configure
}

src_compile() {
	use cjk && autotools-utils_src_compile -C plugins
	autotools-utils_src_compile HTDOCS_SUBDIR=/html
}

src_install() {
	autotools-utils_src_install HTDOCS_SUBDIR=/html
}

pkg_postrm() {
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
}

pkg_postinst() {
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
}
