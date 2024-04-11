# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{10..12} )

inherit ninja-utils python-any-r1
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/google/${PN}.git"
	EGIT_BRANCH="chrome/m$(ver_cut 1)"
else
	MY_PV="1195e70"
	SRC_URI="
		mirror://githubcl/google/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/${PN}-${MY_PV}"
fi

DESCRIPTION="A complete 2D graphic library for drawing Text, Geometries and Images"
HOMEPAGE="https://skia.org"

LICENSE="BSD"
SLOT="0/$(ver_cut 1)"
IUSE="
debug egl ffmpeg fontconfig harfbuzz icu jpeg lottie opengl png static-libs
truetype webp xml
"

RDEPEND="
	xml? ( dev-libs/expat )
	ffmpeg? ( media-video/ffmpeg:= )
	icu? ( dev-libs/icu:= )
	fontconfig? ( media-libs/fontconfig )
	truetype? ( media-libs/freetype )
	harfbuzz? ( media-libs/harfbuzz:= )
	jpeg? ( media-libs/libjpeg-turbo:= )
	png? ( media-libs/libpng:= )
	webp? ( media-libs/libwebp:= )
	sys-libs/zlib
	opengl? ( virtual/opengl )
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	dev-build/gn
"

src_prepare() {
	default

	# https://chromium.googlesource.com/chromium/src/third_party/zlib
	# https://github.com/jtkukunas/zlib
	sed \
		-e '/:zlib_x86/d' \
		-i third_party/zlib/BUILD.gn

	mkdir -p _h/${PN}
	cd _h/${PN}
	cp -a "${S}"/include/* .
	cp -a "${S}"/src/core/SkGeometry.h ./core/
	grep -rl '#include.*"include/' . | xargs sed '/#include/ s:"include/:":' -i
}

src_configure() {
	python_setup
	tc-export AR CC CXX

	local myconf_gn=()
	passflags() {
		local _f _x
		_f=( ${1} )
		_x="[$(printf '"%s", ' "${_f[@]}")]"
		myconf_gn+=( extra_${2}="${_x}" )
	}
	passflags "${CFLAGS}" cflags_c
	passflags "${CXXFLAGS}" cflags_cc
	passflags "${CFLAGS}" ldflags

	my_usex() {
		usex $1 true false
	}
	myconf_gn+=(
		ar=\"${AR}\"
		cc=\"${CC}\"
		cxx=\"${CXX}\"
		is_debug=$(my_usex debug)
		is_official_build=$(my_usex !debug)
		skia_use_system_expat=true
		skia_use_system_freetype2=true
		skia_use_system_harfbuzz=true
		skia_use_system_icu=true
		skia_use_system_libjpeg_turbo=true
		skia_use_system_libpng=true
		skia_use_system_libwebp=true
		skia_use_system_lua=true
		skia_use_system_zlib=true
		skia_enable_spirv_validation=false
		skia_enable_pdf=false
		skia_use_dng_sdk=false
		is_component_build=true
		skia_enable_skottie=$(my_usex lottie)
		skia_use_egl=$(my_usex egl)
		skia_use_expat=$(my_usex xml)
		skia_use_ffmpeg=$(my_usex ffmpeg)
		skia_use_fontconfig=$(my_usex fontconfig)
		skia_use_freetype=$(my_usex truetype)
		skia_use_harfbuzz=$(my_usex harfbuzz)
		skia_enable_skshaper=$(my_usex harfbuzz)
		skia_enable_sktext=$(my_usex harfbuzz)
		skia_use_gl=$(my_usex opengl)
		skia_gl_standard=$(my_usex opengl gl '')
		skia_use_icu=$(my_usex icu)
		skia_use_libjpeg_turbo_decode=$(my_usex jpeg)
		skia_use_libjpeg_turbo_encode=$(my_usex jpeg)
		skia_use_libpng_decode=$(my_usex png)
		skia_use_libpng_encode=$(my_usex png)
		skia_use_libwebp_decode=$(my_usex webp)
		skia_use_libwebp_encode=$(my_usex webp)
		skia_use_sfntly=false
		skia_use_wuffs=false
	)

	myconf_gn="${myconf_gn[@]} ${EXTRA_GN}"
	set -- gn gen --args="${myconf_gn% }" out/Release
	echo "$@"
	"$@" || die
}

src_compile() {
	eninja -C out/Release
}

src_install() {
	dolib.so out/Release/*.so
	use static-libs && dolib.a out/Release/*.a
	doheader -r _h/${PN}
}
