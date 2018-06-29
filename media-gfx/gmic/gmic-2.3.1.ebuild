# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit bash-completion-r1 flag-o-matic qmake-utils toolchain-funcs

if [[ ${PV} == "9999" ]]; then
	EGIT_REPO_URI="https://github.com/dtschump/gmic.git"
	inherit git-r3
else
	SRC_URI="http://gmic.eu/files/source/${PN}_${PV}.tar.gz"
	KEYWORDS="~amd64 ~x86"
	RESTRICT="primaryuri"
fi

DESCRIPTION="GREYC's Magic Image Converter"
HOMEPAGE="http://gmic.eu/ https://github.com/dtschump/gmic"

LICENSE="|| ( CeCILL-C CeCILL-2 )"
SLOT="0"
IUSE="
bash-completion +cli curl ffmpeg fftw gimp graphicsmagick jpeg krita
opencv openexr openmp png qt5 static-libs tiff v4l X zlib
"
REQUIRED_USE="
|| ( cli gimp krita )
gimp? ( qt5 )
krita? ( qt5 )
v4l? ( fftw opencv qt5 )
"

DEPEND="
	fftw? ( sci-libs/fftw:3.0[threads] )
	gimp? ( media-gfx/gimp:2 )
	krita? ( media-gfx/krita )
	qt5? ( dev-qt/qtwidgets:5 )
	graphicsmagick? ( media-gfx/graphicsmagick )
	jpeg? ( virtual/jpeg:0 )
	opencv? ( media-libs/opencv )
	openexr? (
		media-libs/ilmbase
		media-libs/openexr
	)
	png? ( media-libs/libpng:0= )
	tiff? ( media-libs/tiff:0 )
	X? (
		x11-libs/libX11
		x11-libs/libXext
		x11-libs/libxcb
	)
	curl? ( net-misc/curl )
	v4l? ( media-libs/opencv[gstreamer] )
	sys-libs/zlib
"
RDEPEND="
	${COMMON_DEPEND}
	ffmpeg? ( media-video/ffmpeg:0 )
"
DEPEND="
	${DEPEND}
	~media-libs/cimg-${PV}
	virtual/pkgconfig
"

pkg_pretend() {
	if use openmp ; then
		tc-has-openmp || die "Please switch to an openmp compatible compiler"
	fi

	if ! test-flag-CXX -std=c++11 ; then
		die "You need at least GCC 4.7.x or Clang >= 3.3 for C++11-specific compiler flags"
	fi
}

src_prepare() {
	local PATCHES=(
		"${FILESDIR}"/${PN}-qt511.diff
	)
	default
	unpack man/gmic.1.gz
	sed \
		-e "s:pkg-config:$(tc-getPKG_CONFIG):g" \
		-e 's:$(LIBS):$(LDFLAGS) &:' \
		-e '/-o use_lib[c]\?gmic/d' \
		-e '/_libc:/s:libgmic\.o::' \
		-e 's:\<_cli\>:gmic:' \
		-e 's:\<_lib\>:libgmic$(SO):' \
		-e 's:\<_libc\>:libcgmic$(SO):' \
		-e '/-o gmic_cli.o/s:gmic.cpp:gmic_cli.cpp:' \
		-e '/-o gmic gmic_cli.cpp/s:gmic_cli.cpp \(gmic_cli.o.*\):\1 libgmic$(SO):' \
		-e '/libcgmic\$(SO)/s:libgmic\.o :libgmic$(SO) :' \
		-i src/Makefile
	sed \
		-e '/CONFIG += openmp/d' \
		-e '/QMAKE_[A-Z]\+FLAGS_RELEASE +=.* -s/d' \
		-i gmic-qt/gmic_qt.pro zart/zart.pro
	ln -sf "${EROOT}"usr/include/CImg.h src/CImg.h
	sed -e '/#include/s:"\./\(CImg\.h\)":<\1>:' -i src/gmic.h
}

src_configure() {
	use qt5 || return
	local _t myqmakeargs=(
		CONFIG+=release
		CONFIG$(usex openmp + -)=openmp
		GMIC_PATH="${S}"/src
		PRERELEASE=
		GMIC_DYNAMIC_LINKING=on
	)
	for _t in cli gimp krita; do
		if use ${_t}; then
			mkdir -p "${S}"/build/${_t}
			cd "${S}"/build/${_t}
			eqmake5 HOST=${_t/cli/none} "${myqmakeargs[@]}" \
				"${S}"/gmic-qt/gmic_qt.pro
		fi
	done
	use v4l || return
	mkdir -p "${S}"/build/zart
	cd "${S}"/build/zart
	eqmake5 "${myqmakeargs[@]}" "${S}"/zart/zart.pro
}

src_compile() {
	local _t myemakeargs=(
		-C src
		LIB=$(get_libdir)
		OPT_CFLAGS="${CXXFLAGS} -I."
		NOSTRIP=y
		$(usex openmp '' 'OPENMP_CFLAGS= OPENMP_LIBS=')
		$(usex X '' 'X11_CFLAGS= X11_LIBS= XSHM_CFLAGS= XSHM_LIBS=')
		$(usex png '' 'PNG_CFLAGS= PNG_LIBS=')
		$(usex jpeg '' 'JPEG_CFLAGS= JPEG_LIBS=')
		$(usex tiff '' 'TIFF_CFLAGS= TIFF_LIBS=')
		$(usex curl '' 'CURL_CFLAGS= CURL_LIBS=')
		$(usex opencv '' 'OPENCV_CFLAGS= OPENCV_LIBS=')
		$(usex graphicsmagick '' 'MAGICK_CFLAGS= MAGICK_LIBS=')
		$(usex openexr '' 'OPENEXR_CFLAGS= OPENEXR_LIBS=')
		$(usex fftw '' 'FFTW_CFLAGS= FFTW_LIBS=')
	)
	tc-env_build emake "${myemakeargs[@]}" lib
	tc-env_build emake "${myemakeargs[@]}" libc $(usev cli)

	use qt5 || return
	for _t in cli gimp krita; do
		use ${_t} && emake -C "${S}"/build/${_t}
	done
	use v4l && emake -C "${S}"/build/zart
}

src_install() {
	local _l
	for _l in libgmic libcgmic; do
		newlib.so src/${_l}.so ${_l}.so.${PV}
		dosym ${_l}.so.${PV} /usr/$(get_libdir)/${_l}.so.${PV%%.*}
		dosym ${_l}.so.${PV} /usr/$(get_libdir)/${_l}.so
	done
	doheader src/gmic{,_stdlib,_libc}.h

	if use cli; then
		dobin src/gmic
		doman gmic.1
		use qt5 && dobin build/cli/gmic_qt
		use bash-completion && newbashcomp resources/${PN}_bashcompletion.sh ${PN}
	fi

	if use gimp; then
		_l="$($(tc-getPKG_CONFIG) gimp-2.0 --variable=gimplibdir)/plug-ins"
		exeinto "${_l}"
		doexe build/gimp/gmic_gimp_qt
		insinto "${_l}"
		doins resources/gmic_film_cluts.gmz
	fi

	use krita && dobin build/krita/gmic_krita_qt
	use v4l && dobin build/zart/zart

	einstalldocs
}
