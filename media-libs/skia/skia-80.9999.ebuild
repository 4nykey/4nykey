# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python2_7 )

inherit ninja-utils python-any-r1
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/google/${PN}.git"
	EGIT_BRANCH="chrome/m$(ver_cut 1)"
else
	inherit vcs-snapshot
	MY_PV="97c9a95"
	SRC_URI="
		mirror://githubcl/google/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="A complete 2D graphic library for drawing Text, Geometries, and Images"
HOMEPAGE="https://skia.org"

LICENSE="BSD"
SLOT="0/$(ver_cut 1)"
IUSE="static-libs"

RDEPEND="
	dev-libs/expat
	dev-libs/icu
	media-libs/fontconfig
	media-libs/freetype
	media-libs/harfbuzz
	media-libs/libjpeg-turbo
	media-libs/libpng
	media-libs/libwebp
	sys-libs/zlib
	virtual/opengl
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	dev-util/gn
"

src_prepare() {
	default
	# https://chromium.googlesource.com/chromium/src/third_party/zlib
	# https://github.com/jtkukunas/zlib
	sed \
		-e '/:zlib_x86/d' \
		-e '/third_party("zlib_x86/,/^}/d' \
		-i third_party/zlib/BUILD.gn
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

	myconf_gn+=(
		ar=\"${AR}\"
		cc=\"${CC}\"
		cxx=\"${CXX}\"
		is_official_build=true
		skia_enable_pdf=false
		skia_use_dng_sdk=false
		is_component_build=true
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
	insinto /usr/include/${PN}
	doins -r include/.
}
