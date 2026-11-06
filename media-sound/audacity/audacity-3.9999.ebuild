# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

WX_GTK_VER="3.2-gtk3"
inherit plocale cmake flag-o-matic wxwidgets xdg virtualx
# locale/LINGUAS
PLOCALES="
af ar be bg bn bs ca ca_ES@valencia co cs cy da de el es eu eu_ES fa fi fr ga
gl he hi hr hu hy id it ja ka km ko lt mk mr my nb nl oc pl pt_BR pt_PT ro ru
sk sl sr_RS sr_RS@latin sv ta tg tr uk vi zh_CN zh_TW
"
MY_DOC="${PN^}-3.7.0"
if [[ -z ${PV%%*9999} ]]; then
	EGIT_REPO_URI="https://github.com/${PN}/${PN}.git"
	inherit git-r3
else
	MY_PV="$(ver_rs 3-4 '-')"
	MY_PV="${MY_PV/-rc-/-RC}"
	MY_PV="${PN^}-${MY_PV%_*}"
	if [[ -z ${PV%%*_p*} ]]; then
		MY_PV="30cc55b"
		SRC_URI="
			mirror://githubcl/${PN}/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
		"
		S="${WORKDIR}/${PN}-${MY_PV}"
	else
		MY_P="${PN}-sources-${MY_PV#*-}"
		SRC_URI="
			https://github.com/${PN}/${PN}/releases/download/${MY_PV}/${MY_P}.tar.gz
		"
		S="${WORKDIR}/${MY_P}"
	fi
	KEYWORDS="~amd64"
fi
DESCRIPTION="Free crossplatform audio editor"
HOMEPAGE="https://web.audacityteam.org/"

MY_TP="ThreadPool-9a42ec1"
SRC_URI+="
	curl? (
		mirror://githubcl/progschj/${MY_TP%-*}/tar.gz/${MY_TP##*-} -> ${MY_TP}.tar.gz
	)
	doc? (
		https://github.com/${PN}/${PN}/releases/download/${MY_DOC}/${PN}-manual-${MY_DOC#*-}.tar.gz
	)
"

LICENSE="GPL-3"
SLOT="0"
IUSE="
alsa curl doc ffmpeg +flac id3tag jack +ladspa +lv2 mpg123
nls ogg opus oss pch +portmixer sbsms +soundtouch twolame vamp +vorbis
vst wavpack
"
RESTRICT="test primaryuri"

DEPEND="
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
		media-libs/vst3sdk
		x11-libs/libX11
	)
	wavpack? ( media-sound/wavpack )
"
RDEPEND="
	${DEPEND}
	ffmpeg? ( media-video/ffmpeg:= )
"
BDEPEND="
	doc? ( app-arch/unzip )
	virtual/pkgconfig
	nls? ( sys-devel/gettext )
"

PATCHES=(
	# fixes include path
	"${FILESDIR}/audacity-3.7.0-portsmf.patch"

	# disables ccache
	"${FILESDIR}/audacity-3.7.0-disable-ccache.patch"

	# Disables some header-based detection
	"${FILESDIR}/audacity-3.7.0-allow-overriding-alsa-jack.patch"

	# For has_networking
	"${FILESDIR}/audacity-3.7.0-local-threadpool-libraries.patch"

	# Allows running tests without conan
	"${FILESDIR}/audacity-3.3.3-remove-conan-test-dependency.patch"

	# #920363
	"${FILESDIR}/audacity-3.7.0-audiocom-std-string.patch"

	# 915041
	"${FILESDIR}/audacity-3.7.0-do-not-include-template-on-unix-to-fix-clang-compile.patch"
)
PATCHES+=(
	"${FILESDIR}"/vst3.diff
	"${FILESDIR}"/rapidjson.diff
)

src_prepare() {
	rm_locale() {
		sed -e "/${1}/d" -i locale/LINGUAS
	}
	if use nls; then
		plocale_for_each_disabled_locale rm_locale
	else
		sed -e '/add_subdirectory( "locale" )/d' -i CMakeLists.txt || die
		sed \
			-e '/add_dependencies( \${TARGET} locale )/d' \
			-i src/CMakeLists.txt || die
	fi
	sed \
		-e "s:/\<lib\>:/$(get_libdir):" \
		-e "/share\/doc/ s:\<audacity\>:${PF}:" \
		-i libraries/lib-files/PathList.cpp

	cmake_src_prepare

	use curl || return
	mv "${WORKDIR}"/${MY_TP} "${S}"/libraries/lib-network-manager/${MY_TP%-*}
	sed -e '/audacity_find_package(ThreadPool/d' \
		-i cmake-proxies/cmake-modules/DependenciesList.cmake
	sed -e '/threadpool::threadpool/d' -i libraries/lib-network-manager/CMakeLists.txt
}

src_configure() {
	append-flags -fno-strict-aliasing
	setup-wxwidgets
	local _r=2
	case ${PV} in
		*_beta*) _r=1 ;;
		*_p*|9999*) _r=0 ;;
	esac
	# * always use system libraries if possible
	# * options listed in the order that cmake-gui lists them
	local mycmakeargs=(
		-DAUDACITY_BUILD_LEVEL=${_r}
		-Daudacity_conan_enabled=off
		-Daudacity_has_networking=$(usex curl)
		-Daudacity_has_updates_check=off
		-Daudacity_has_crashreports=off
		-Daudacity_has_sentry_reporting=off

		-Daudacity_has_tests=$(usex test)

		-Daudacity_lib_preference=system
		-Daudacity_obey_system_dependencies=yes
		-Daudacity_use_expat=system
		-Daudacity_use_ffmpeg=$(usex ffmpeg loaded off)
		-Daudacity_use_ladspa=$(usex ladspa)
		-Daudacity_use_lame=system
		-Daudacity_use_libid3tag=$(usex id3tag system off)
		-Daudacity_use_libflac=$(usex flac system off)
		-Daudacity_use_libmp3lame=system
		-Daudacity_use_libmpg123=$(usex mpg123 system off)
		-Daudacity_use_libogg=$(usex ogg system off)
		-Daudacity_use_libopus=$(usex opus system off)
		-Daudacity_use_libsndfile=system
		-Daudacity_use_libvorbis=$(usex vorbis system off)
		-Daudacity_use_lv2=$(usex lv2 system off)
		-Daudacity_use_midi=system
		-Daudacity_use_nyquist=local
		-Daudacity_use_opusfile=$(usex opus system off)
		-Daudacity_use_pch=$(usex pch)
		-Daudacity_use_portaudio=system
		-Daudacity_use_portmixer=$(usex portmixer system off)
		-Daudacity_use_portsmf=system
		-Daudacity_use_rapidjson=system
		-Daudacity_use_sbsms=$(usex sbsms system off)
		-Daudacity_use_soundtouch=$(usex soundtouch system off)
		-Daudacity_use_soxr=system
		-Daudacity_use_twolame=$(usex twolame system off)
		-Daudacity_use_vamp=$(usex vamp system off)
		-Daudacity_use_libvorbis=$(usex vorbis system off)
		-Daudacity_use_wavpack=$(usex wavpack system off)
		-Daudacity_use_wxwidgets=system

		# See the allow-overriding-alsa-jack.patch patch
		-DPA_HAS_ALSA=$(usex alsa on off)

		-Daudacity_has_vst3=$(usex vst)
	)
	[[ -n ${PV%%*9999} ]] && mycmakeargs+=(
		-DCMAKE_DISABLE_FIND_PACKAGE_Git=yes
	)
	cmake_src_configure
}

src_compile() {
	LD_LIBRARY_PATH="${BUILD_DIR}/Gentoo/$(get_libdir)/${PN}" \
	cmake_src_compile
}

src_test() {
	virtx cmake_src_test
}

src_install() {
	cmake_src_install

	# Remove bad doc install
	rm -r "${ED}"/usr/share/doc || die

	if use doc ; then
		docinto html
		dodoc -r "${WORKDIR}"/help/manual/.
		dosym ../../doc/${PF}/html /usr/share/${PN}/help/manual
	fi
}
