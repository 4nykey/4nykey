# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

WX_GTK_VER="3.2-gtk3"
inherit cmake wxwidgets xdg virtualx
if [[ -z ${PV%%*9999} ]]; then
	EGIT_REPO_URI="https://github.com/${PN}/${PN}.git"
	inherit git-r3
else
	MY_PV="$(ver_rs 3-4 '-')"
	MY_PV="${MY_PV/-rc-/-RC}"
	MY_PV="${PN^}-${MY_PV%_*}"
	MY_P="${PN}-sources-${MY_PV#*-}"
	SRC_URI="
		https://github.com/${PN}/${PN}/releases/download/${MY_PV}/${MY_P}.tar.xz
	"
	KEYWORDS="~amd64"
	# muse_deps/recipes/googletest/spec.cmake
	MY_GT="googletest-1.17.0"
	SRC_URI+="
		test? (
			mirror://githubcl/google/${MY_GT%-*}/tar.gz/v${MY_GT##*-}
			-> ${MY_GT}.tar.gz
		)
	"
fi
DESCRIPTION="Free crossplatform audio editor"
HOMEPAGE="https://web.audacityteam.org"

LICENSE="GPL-3"
SLOT="4"
IUSE="
alsa curl doc ffmpeg +flac id3tag jack +ladspa +lv2 mpg123
ogg opus oss pch +portmixer sbsms +soundtouch twolame vamp +vorbis
vst wavpack
"
RESTRICT="primaryuri"

DEPEND="
	dev-qt/qtbase:6=[concurrent,gui,network,widgets]
	dev-qt/qt5compat:6=
	dev-qt/qtdeclarative:6=
	dev-qt/qtsvg:6=
	media-libs/portaudio[alsa?]
	media-libs/portmidi
	media-libs/portsmf:=
	dev-libs/expat
	media-libs/libsndfile
	media-libs/libsoundtouch
	media-libs/soxr
	>=media-sound/lame-3.100-r3
	x11-libs/wxGTK:${WX_GTK_VER}=[X,regex(+)]
	dev-db/sqlite:3
	alsa? ( media-libs/alsa-lib )
	curl? (
		net-misc/curl
		dev-libs/rapidjson
	)
	flac? ( media-libs/flac:=[cxx] )
	id3tag? ( media-libs/libid3tag:= )
	jack? ( virtual/jack )
	lv2? (
		dev-libs/serd
		dev-libs/sord
		media-libs/lilv
		media-libs/lv2
		media-libs/sratom
		media-libs/suil
	)
	mpg123? ( media-sound/mpg123-base )
	ogg? ( media-libs/libogg )
	opus? (
		media-libs/opus
		media-libs/opusfile
	)
	sbsms? ( media-libs/libsbsms:= )
	soundtouch? ( >=media-libs/libsoundtouch-1.7.1 )
	twolame? ( media-sound/twolame )
	vamp? ( media-libs/vamp-plugin-sdk )
	vorbis? ( media-libs/libvorbis )
	vst? (
		x11-libs/libX11
	)
	wavpack? ( media-sound/wavpack )
	dev-libs/pugixml
	dev-cpp/picojson
"
RDEPEND="
	${DEPEND}
	ffmpeg? ( media-video/ffmpeg:= )
"
BDEPEND="
	virtual/pkgconfig
"
PATCHES=(
	"${FILESDIR}"/system-libs.diff
	"${FILESDIR}"/inc.diff
	"${FILESDIR}"/link.diff
)

src_prepare() {
	sed \
		-e "s:/\<lib\>:/$(get_libdir):" \
		-e "/share\/doc/ s:\<audacity\>:${PF}:" \
		-i au3/libraries/au3-files/PathList.cpp
	sed -e 's: Portable::' -i \
		buildscripts/packaging/Linux+BSD/SetupAppImagePackaging.cmake

	if use test; then
		mkdir -p offline-deps/downloads/googletest
		ln -s "${DISTDIR}"/${MY_GT}.tar.gz offline-deps/downloads/googletest/v${MY_GT##*-}.tar.gz
	fi
	find -type f -name '._*' -delete
	cmake_src_prepare
}

src_configure() {
	setup-wxwidgets
	local mycmakeargs=(
		-DEXTDEPS_CACHE="${S}/offline-deps"
		-DAU4_BUILD_MODE="release"
		-DMUSE_APP_INSTALL_SUFFIX=${SLOT}
		-DMUSE_ENABLE_UNIT_TESTS=$(usex test)
		-DMUSE_COMPILE_USE_UNITY=no
		-DMUSE_COMPILE_USE_CCACHE=no
		-DMUSE_COMPILE_USE_PCH=$(usex pch)
		-DMUSE_MODULE_DIAGNOSTICS=no
		-DMUSE_MODULE_DIAGNOSTICS_CRASHPAD_CLIENT=no
		-DAU_LOAD_TIMETRACK=yes

		-DAU_USE_LIBCURL=$(usex curl)
		-DAU_BUILD_CLOUD_AUDIOCOM=$(usex curl)
		-DAU_BUILD_USAGEINFO_MODULE=no

		-DAU_MODULE_EFFECTS_NYQUIST=yes
		-DAU_MODULE_EFFECTS_VST=$(usex vst)
		-DMUSE_MODULE_VST=$(usex vst)
		-DAU_MODULE_EFFECTS_LV2=$(usex lv2)
		-DAU_USE_SBSMS=$(usex sbsms)
		-DAU_USE_SOUNDTOUCH=$(usex soundtouch)
		-DAU_USE_PORTMIXER=$(usex portmixer)
	)
	cmake_src_configure
}

src_test() {
	virtx cmake_src_test
}
