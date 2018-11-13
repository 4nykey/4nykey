# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools multilib-minimal vcs-snapshot

DESCRIPTION="GTK+ version of wxWidgets, a cross-platform C++ GUI toolkit"
HOMEPAGE="http://wxwidgets.org/"

MY_PV="cd11d91"
[[ -n ${PV%%*_p*} ]] && MY_PV="v${PV}"
SRC_URI="
	mirror://githubcl/wxwidgets/wxwidgets/tar.gz/${MY_PV} -> ${P}.tar.gz
"
RESTRICT=primaryuri

KEYWORDS="~amd64 ~x86"
IUSE="+X debug gstreamer libnotify chm opengl sdl tiff"

SLOT="${PV:0:3}"

RDEPEND="
	dev-libs/expat[${MULTILIB_USEDEP}]
	sdl?    ( media-libs/libsdl[${MULTILIB_USEDEP}] )
	X?  (
		>=dev-libs/glib-2.22:2[${MULTILIB_USEDEP}]
		media-libs/libpng:0=[${MULTILIB_USEDEP}]
		sys-libs/zlib[${MULTILIB_USEDEP}]
		virtual/jpeg:0=[${MULTILIB_USEDEP}]
		x11-libs/cairo[${MULTILIB_USEDEP}]
		x11-libs/gtk+:2[${MULTILIB_USEDEP}]
		x11-libs/gdk-pixbuf[${MULTILIB_USEDEP}]
		x11-libs/libSM[${MULTILIB_USEDEP}]
		x11-libs/libX11[${MULTILIB_USEDEP}]
		x11-libs/libXxf86vm[${MULTILIB_USEDEP}]
		x11-libs/pango[${MULTILIB_USEDEP}]
		gstreamer? (
			media-libs/gstreamer:0.10[${MULTILIB_USEDEP}]
			media-libs/gst-plugins-base:0.10[${MULTILIB_USEDEP}] )
		libnotify? ( x11-libs/libnotify[${MULTILIB_USEDEP}] )
		opengl? ( virtual/opengl[${MULTILIB_USEDEP}] )
		tiff?   ( media-libs/tiff:0[${MULTILIB_USEDEP}] )
	)
	chm? ( dev-libs/libmspack )
"

DEPEND="
	${RDEPEND}
	virtual/pkgconfig[${MULTILIB_USEDEP}]
	opengl? ( virtual/glu[${MULTILIB_USEDEP}] )
	X?  ( x11-base/xorg-proto )
"

PDEPEND=">=app-eselect/eselect-wxwidgets-20131230"

LICENSE="wxWinLL-3 GPL-2"
DOCS=(
	docs/{changes,readme}.txt
	docs/{base,gtk}
)

src_prepare() {
	default

	local f
	for f in $(find "${S}" -name configure.in); do
		mv "${f}" "${f/in/ac}" || die
	done
	AT_M4DIR="${S}/build/aclocal" eautoreconf

	# Versionating
	sed -i \
		-e "s:\(WX_RELEASE = \).*:\1${SLOT}:" \
		-e "s:\(WX_RELEASE_NODOT = \).*:\1${SLOT//.}:" \
		-e "s:\(WX_VERSION = \).*:\1${PV:0:5}:" \
		-e "s:aclocal):aclocal/wxwin${SLOT//.}.m4):" \
		-e "s:wxstd.mo:wxstd${SLOT//.}:" \
		-e "s:wxmsw.mo:wxmsw${SLOT//.}:" \
		Makefile.in || die

	sed -i \
		-e "s:\(WX_RELEASE = \).*:\1${SLOT}:"\
		utils/wxrc/Makefile.in || die

	sed -i \
		-e "s:\(WX_VERSION=\).*:\1${PV:0:5}:" \
		-e "s:\(WX_RELEASE=\).*:\1${SLOT}:" \
		-e "s:\(WX_SUBVERSION=\).*:\1${PV}:" \
		-e "/WX_VERSION_TAG=/ s:\${WX_RELEASE}:${PV:0:3}:" \
		configure || die
}

multilib_src_configure() {
	local myconf

	# X independent options
	myconf="
			--with-zlib=sys
			--with-expat=sys
			--enable-compat28
			$(use_with sdl)"

	# debug in >=2.9
	# there is no longer separate debug libraries (gtk2ud)
	# wxDEBUG_LEVEL=1 is the default and we will leave it enabled
	# wxDEBUG_LEVEL=2 enables assertions that have expensive runtime costs.
	# apps can disable these features by building w/ -NDEBUG or wxDEBUG_LEVEL_0.
	# http://docs.wxwidgets.org/3.0/overview_debugging.html
	# https://groups.google.com/group/wx-dev/browse_thread/thread/c3c7e78d63d7777f/05dee25410052d9c
	use debug \
		&& myconf="${myconf} --enable-debug=max"

	# wxGTK options
	#   --enable-graphics_ctx - needed for webkit, editra
	#   --without-gnomevfs - bug #203389
	use X && \
		myconf="${myconf}
			--enable-graphics_ctx
			--with-gtkprint
			--enable-gui
			--with-gtk=2
			--with-libpng=sys
			--with-libjpeg=sys
			--without-gnomevfs
			$(use_enable gstreamer mediactrl)
			--disable-webview
			$(use_with libnotify)
			$(use_with opengl)
			$(use_with tiff libtiff sys)
			$(use_with chm libmspack)
		"

	# wxBase options
	use X || myconf="${myconf} --disable-gui"

	ECONF_SOURCE="${S}" econf ${myconf}
}

multilib_src_install_all() {
	einstalldocs
	# Unversioned links
	rm "${D}"/usr/bin/wx{-config,rc}

	# version bakefile presets
	pushd "${D}"usr/share/bakefile/presets/ > /dev/null
	for f in wx*; do
		mv "${f}" "${f/wx/wx${SLOT//.}}"
	done
	popd > /dev/null
}

pkg_postinst() {
	has_version app-eselect/eselect-wxwidgets \
		&& eselect wxwidgets update
}

pkg_postrm() {
	has_version app-eselect/eselect-wxwidgets \
		&& eselect wxwidgets update
}
