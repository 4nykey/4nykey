# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake virtualx

DESCRIPTION="A cross-platform C++ GUI toolkit"
HOMEPAGE="https://wxwidgets.org"
VIRTUALX_REQUIRED="X"

MY_PV="204db7e"
[[ -n ${PV%%*_p*} ]] && MY_PV="v${PV}"
MY_CA="Catch-5f5e4ce"
MY_LEX="lexilla-696ee98"
MY_SCI="scintilla-0b90f31"
SRC_URI="
	mirror://githubcl/${PN}/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	stc? (
		mirror://githubcl/${PN}/${MY_LEX%-*}/tar.gz/${MY_LEX#*-} -> ${MY_LEX}.tar.gz
		mirror://githubcl/${PN}/${MY_SCI%-*}/tar.gz/${MY_SCI#*-} -> ${MY_SCI}.tar.gz
	)
	test? (
		mirror://githubcl/${PN}/${MY_CA%-*}/tar.gz/${MY_CA##*-}
		-> ${MY_CA}.tar.gz
	)
"
S="${WORKDIR}/${PN}-${MY_PV#v}"

LICENSE="wxWinLL-3 GPL-2 doc? ( wxWinFDL-3 )"
SLOT="$(ver_cut 1-2)/$(ver_cut 3)"
KEYWORDS="~amd64"
IUSE="+X curl doc debug keyring gstreamer libnotify +lzma opengl pch sdl +spell test tiff wayland webkit"
IUSE+=" chm egl gtk3 gtk4 pcre qt6 stc svg threads"
REQUIRED_USE="
	egl? ( opengl )
	test? ( tiff )
	tiff? ( X )
	spell? ( X )
	keyring? ( X )
	X? ( || ( gtk3 gtk4 qt6 ) )
	webkit? ( X gtk3 )
"
RESTRICT="!test? ( test )"
RESTRICT+=" primaryuri"

RDEPEND="
	>=dev-libs/glib-2.22:2
	dev-libs/expat
	pcre? ( dev-libs/libpcre2[pcre16,pcre32,unicode] )
	sdl? ( media-libs/libsdl2 )
	curl? ( net-misc/curl )
	lzma? ( app-arch/xz-utils )
	X? (
		media-libs/libjpeg-turbo:=
		media-libs/libpng:0=
		virtual/zlib:=
		x11-libs/cairo
		x11-libs/libSM
		x11-libs/libX11
		x11-libs/libXtst
		x11-libs/libXxf86vm
		media-libs/fontconfig
		x11-libs/pango
		keyring? ( app-crypt/libsecret )
		gstreamer? (
			media-libs/gstreamer:1.0
			media-libs/gst-plugins-base:1.0
			media-libs/gst-plugins-bad:1.0
		)
		>=dev-libs/glib-2.22:2
		libnotify? ( x11-libs/libnotify )
		opengl? (
			virtual/opengl
			wayland? ( dev-libs/wayland )
		)
		spell? ( app-text/gspell:= )
		tiff? ( media-libs/tiff:= )
		webkit? ( net-libs/webkit-gtk:4.1= )
	)
	gtk3? (
		>=x11-libs/gtk+-3.24.41-r1:3[wayland?,X?]
		x11-libs/gdk-pixbuf:2
	)
	gtk4? (
		gui-libs/gtk:4[wayland?,X?]
		x11-libs/gdk-pixbuf:2
	)
	qt6? (
		dev-qt/qtbase:6=[gui,opengl,widgets]
	)
	chm? ( dev-libs/libmspack )
	svg? ( media-libs/nanosvg )
"
DEPEND="
	${RDEPEND}
	opengl? ( virtual/glu )
	X? ( x11-base/xorg-proto )
"
BDEPEND="
	test? ( >=dev-util/cppunit-1.8.0 )
	>=app-eselect/eselect-wxwidgets-20131230
	virtual/pkgconfig
"
DOCS=(
	docs/{changes,readme}.txt
	docs/{base,gtk}
)
PATCHES=(
	"${FILESDIR}"/cmake.diff
)

src_prepare() {
	use test && mv "${WORKDIR}"/${MY_CA}/* 3rdparty/catch
	if use stc; then
		mv "${WORKDIR}"/${MY_LEX}/* src/stc/lexilla
		mv "${WORKDIR}"/${MY_SCI}/* src/stc/scintilla
	fi
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DwxUSE_GUI=$(usex X)
		-DwxUSE_ZLIB=sys
		-DwxUSE_EXPAT=sys
		-DwxUSE_THREADS=$(usex threads)
		-DwxUSE_LIBSDL=$(usex sdl)
		-DwxUSE_REGEX=$(usex pcre sys no)
		-DwxUSE_LIBLZMA=$(usex lzma)
		-DwxUSE_WEBREQUEST_CURL=$(usex curl)
		-DwxBUILD_DEBUG_LEVEL=$(usex debug 2 1)
		-DwxBUILD_TESTS=$(usex test $(usex X ALL CONSOLE_ONLY))
	)
	if use X; then
		mycmakeargs+=(
			-DwxUSE_GRAPHICS_CONTEXT=yes
			-DwxUSE_GTKPRINT=sys
			-DwxUSE_LIBPNG=sys
			-DwxUSE_LIBJPEG=sys
			-DwxUSE_LIBGNOMEVFS=no
			-DwxUSE_MEDIACTRL=$(usex gstreamer)
			-DwxUSE_LIBNOTIFY=$(usex libnotify)
			-DwxUSE_OPENGL=$(usex opengl)
			-DwxUSE_LIBTIFF=$(usex tiff sys no)
			-DwxUSE_SECRETSTORE=$(usex keyring)
			-DwxUSE_SPELLCHECK=$(usex spell)
			-DwxUSE_NANOSVG=$(usex svg sys no)
			-DwxUSE_GLCANVAS_EGL=$(usex egl)
			-DwxUSE_LIBMSPACK=$(usex chm)
			-DwxUSE_STC=$(usex stc)
			-DwxUSE_DETECT_SM=yes
		)
		if use gtk3; then
			mycmakeargs+=(
				-DwxBUILD_TOOLKIT=gtk3
				-DwxUSE_WEBVIEW=$(usex webkit)
			)
			BUILD_DIR="${CMAKE_USE_DIR}_gtk3" \
				cmake_src_configure
		fi
		if use gtk4; then
			mycmakeargs+=(
				-DwxBUILD_TOOLKIT=gtk4
			)
			BUILD_DIR="${CMAKE_USE_DIR}_gtk4" \
				cmake_src_configure
		fi
		if use qt6; then
			mycmakeargs+=(
				-DwxBUILD_TOOLKIT=qt
			)
			BUILD_DIR="${CMAKE_USE_DIR}_qt6" \
				cmake_src_configure
		fi
	else
		cmake_src_configure
	fi
}

src_compile() {
	if use X; then
		use gtk3 && BUILD_DIR="${CMAKE_USE_DIR}_gtk3" \
				cmake_src_compile
		use gtk4 && BUILD_DIR="${CMAKE_USE_DIR}_gtk4" \
				cmake_src_compile
		use qt6 && BUILD_DIR="${CMAKE_USE_DIR}_qt6" \
				cmake_src_compile
	else
		cmake_src_compile
	fi
}

src_test() {
	if use X; then
		use gtk3 && BUILD_DIR="${CMAKE_USE_DIR}_gtk3" \
			virtx cmake_src_test
		use gtk4 && BUILD_DIR="${CMAKE_USE_DIR}_gtk4" \
			virtx cmake_src_test
		use qt6 && BUILD_DIR="${CMAKE_USE_DIR}_qt6" \
			virtx cmake_src_test
	else
		cmake_src_test
	fi
}

src_install() {
	if use X; then
		local _c _p=( ) _e
		if use gtk3; then
			_c=/usr/share/wx/gtk3
			dodir "${_c}"
			BUILD_DIR="${CMAKE_USE_DIR}_${_c##*/}" cmake_src_install
			mv "${ED}"/usr/lib64/cmake "${ED}${_c}"
			_p+=( "${EPREFIX}${_c}" )
		fi
		if use gtk4; then
			_c=/usr/share/wx/gtk4
			dodir "${_c}"
			BUILD_DIR="${CMAKE_USE_DIR}_${_c##*/}" cmake_src_install
			mv "${ED}"/usr/lib64/cmake "${ED}${_c}"
			_p+=( "${EPREFIX}${_c}" )
		fi
		if use qt6; then
			_c=/usr/share/wx/qt6
			dodir "${_c}"
			BUILD_DIR="${CMAKE_USE_DIR}_${_c##*/}" cmake_src_install
			mv "${ED}"/usr/lib64/cmake "${ED}${_c}"
			_p+=( "${EPREFIX}${_c}" )
		fi
		_c="$(printf '%s/cmake:' ${_p[@]})"
		_e="${T}/99${PN}${SLOT%/*}"
		printf 'CMAKE_PREFIX_PATH="%s:${CMAKE_PREFIX_PATH}"\n' "${_c}" >\
			"${_e}"
		doenvd "${_e}"
	else
		cmake_src_install
	fi
	# Unversioned links
	rm -f "${ED}"/usr/bin/wx{-config,rc}
}
