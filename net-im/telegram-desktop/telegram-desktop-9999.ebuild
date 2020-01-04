# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PN=tdesktop
if [[ -z ${PV%%*9999} ]]; then
	EGIT_REPO_URI="https://github.com/telegramdesktop/${MY_PN}.git"
	EGIT_BRANCH="dev"
	EGIT_SUBMODULES=(
		'*'
		'-Telegram/ThirdParty/libtgvoip'
		'-Telegram/ThirdParty/rlottie'
		'-Telegram/ThirdParty/lz4'
	)
	inherit git-r3
else
	MY_P="${MY_PN}-${PV}-full"
	SRC_URI="
		https://github.com/telegramdesktop/${MY_PN}/releases/download/v${PV}/${MY_P}.tar.gz
	"
	S="${WORKDIR}/${MY_P}"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi
MY_DEB="${PN}-patches-dc0956c"
SRC_URI+="
	mirror://githubcl/4nykey/${MY_DEB%-*}/tar.gz/${MY_DEB##*-} -> ${MY_DEB}.tar.gz
"
CMAKE_USE_DIR="${S}/out/Release"
PYTHON_COMPAT=( python2_7 )
inherit python-any-r1 toolchain-funcs flag-o-matic desktop xdg cmake-utils

DESCRIPTION="Telegram Desktop messaging app"
HOMEPAGE="https://desktop.telegram.org"

LICENSE="GPL-3"
SLOT="0"
IUSE="crashreporter gtk +packed-resources test"

RDEPEND="
	dev-qt/qtmultimedia:5
	dev-qt/qtgui:5[xcb]
	dev-qt/qtnetwork:5
	dev-qt/qtimageformats:5
	dev-qt/qtprintsupport:5
	dev-qt/qtwidgets:5[gtk?]
	sys-libs/zlib[minizip]
	app-arch/lz4
	app-arch/xz-utils
	dev-libs/openssl:0
	media-libs/libexif
	virtual/ffmpeg
	media-libs/openal
	media-libs/opus
	media-libs/libexif
	x11-libs/libva[X]
	gtk? (
		x11-libs/gtk+:3
		dev-libs/libappindicator:3
	)
	>=media-libs/libtgvoip-2.4.4_p20190715-r1
	media-libs/rlottie
	x11-libs/libxkbcommon
	crashreporter? ( dev-libs/breakpad )
"
DEPEND="
	${RDEPEND}
	dev-cpp/range-v3
"
RDEPEND="
	${RDEPEND}
	media-fonts/open-sans
"
BDEPEND="
	dev-util/gyp
	virtual/pkgconfig
"

pkg_pretend() {
	[[ -n ${TELEGRAM_API_ID} ]] && [[ -n ${TELEGRAM_API_HASH} ]] && return
	ewarn "
A sample API ID included with the code is limited on the server side.
You can get your own key and provide it via TELEGRAM_API_ID and
TELEGRAM_API_HASH environment variables.
See https://core.telegram.org/api/obtaining_api_id
"
}

pkg_setup() {
	EGIT_SUBMODULES+=( $(usex test '' '-Telegram/ThirdParty/Catch') )
	python-any-r1_pkg_setup
	use packed-resources && append-cppflags -DTDESKTOP_USE_PACKED_RESOURCES
}

src_prepare() {
	unpack ${MY_DEB}.tar.gz
	mv ${MY_DEB}/debian .
	rm -rf Telegram/ThirdParty/{libtgvoip,lz4,minizip,rlottie}

	local _patches=(
		debian/patches
		"${FILESDIR}"/${PN}-gyp.diff
		"${FILESDIR}"/${PN}-pch.diff
		"${FILESDIR}"/${PN}-breakpad.diff
	)
	eapply "${_patches[@]}"

	local _p="$(tc-getPKG_CONFIG)" _q=$(best_version dev-qt/qtgui:5) \
	_l=(
		icu-i18n
		libavcodec
		libavformat
		libavutil
		libcrypto
		libexif
		liblz4
		liblzma
		libssl
		libswresample
		libswscale
		libtgvoip
		libva-x11
		minizip
		openal
		opus
		rlottie
		xkbcommon
		$(usex gtk 'appindicator3-0.1' '')
		$(usex crashreporter 'breakpad-client' '')
	)
	local _f=(
		$(${_p} --cflags ${_l[@]})
		-I"${EPREFIX}"/usr/include/range/v3
	)
	local _d=(
		TDESKTOP_DISABLE_UNITY_INTEGRATION
		$(usex crashreporter '' 'TDESKTOP_DISABLE_CRASH_REPORTS')
		TDESKTOP_DISABLE_AUTOUPDATE
		$(usex gtk '' 'TDESKTOP_DISABLE_GTK_INTEGRATION')
	)
	_d=$(printf ',%s' "${_d[@]}")
	_q=${_q#dev-qt/qtgui-}
	local mygypargs=(
		--format=cmake
		--depth=Telegram/gyp
		--generator-output=../..
		-Gconfig=${CMAKE_USE_DIR##*/}
		-Dspecial_build_target=
		-Dapi_id=${TELEGRAM_API_ID:-17349}
		-Dapi_hash=${TELEGRAM_API_HASH:-344583e45741c457fe1862106095a5eb}
		-Duse_packed_resources=$(usex packed-resources 1 0)
		-Dnot_need_gtk="True"
		-Dmy_cflags="${_f[*]}"
		-Dqt_version=${_q%[-_]*}
		-Dlinux_path_qt="${EPREFIX}/usr/$(get_libdir)/qt5"
		-Dlinux_path_opus_include="${EPREFIX}/usr/include/opus"
		-Dminizip_loc="${EPREFIX}/usr/include/minizip"
		-Dbuild_defines="${_d:1}"
		-Dqt_bindir="${EPREFIX}/usr/$(get_libdir)/qt5/bin"
		-Dlinux_path_breakpad="${EPREFIX}/usr"
	)

	cd "${S}"/Telegram/gyp

	use test || sed -e '/\<tests\>/d' -i Telegram.gyp
	sed \
		-e "s%target_name': 'tests_storage',%& 'libraries': ['crypto',],%" \
		-i tests/tests.gyp

	grep -rl 'libs_loc)/' | xargs sed -e '/<(libs_loc)\//d' -i
	sed -e '/qt_static_plugins/d' -i telegram/sources.txt
	sed \
		-e '/utils.gyp:\(Updater\|Packer\)/d' \
		-e '/libtgvoip.gyp/d' \
		-e '/\<\(AL_LIBTYPE_STATIC\|minizip_loc\)\>/d' \
		-i Telegram.gyp
	sed \
		-e '/\<\(qwebp\|Qt5PlatformSupport\|qtharfbuzz\|qtlibpng\|qtpcre2\)\>/d' \
		-e '/\<\(qconnmanbearer\|qgenericbearer\|qnmbearer\|xcb-static\)\>/d' \
		-e '/-\<l[a-z]\+platforminputcontextplugin\>/d' \
		-e '/<(linux_lib_/d' \
		-e '/linux_glibc_wraps/d' \
		-e "s:<!@(python -c .*\(<@(qt_libs)\).*:\1',:" \
		-e '/\<qt_loc\>/s:\(/include\):/../..\1/qt5:' \
		-e "/linux_path_xkbcommon/d" \
		-e '/-static-libstdc++/d' \
		-i helpers/modules/qt.gypi
	sed \
		-e '/-\<Werror\>/d' \
		-e "/'QT_STATICPLUGIN',/d" \
		-i helpers/common/linux.gypi
	_l=( ${_l[@]/%/\',} )
	_l="${_l[@]/#/\'}"
	sed \
		-e "s%'pkgconfig_libs': \[%& ${_l}%" \
		-e "/\<\(include\|library\)_dirs\>': \[/,/\]\,/d" \
		-e '/-\(Ofast\|flto\|Wl,-\)/d' \
		-i telegram/linux.gypi
	sed -ze \
		"s%\('libraries': \[\).*\n#\([ ]\+'<!(\)pkg-config\( .*pkgconfig_libs))',\)%\1\
		\n\2${_p}\3%" \
		-i telegram/linux.gypi

	cd "${S}"
	sed -e '/lib_\(rlottie\|lz4\)/d' -i Telegram/lib_lottie/lib_lottie.gyp
	use crashreporter || sed \
		-e '/crash_report_/d' -i Telegram/lib_base/gyp/sources.txt

	set -- gyp "${mygypargs[@]}" Telegram/gyp/Telegram.gyp
	einfo "${@}"
	"${@}" || die "gyp failed"

	cmake-utils_src_prepare

	cat debian/CMakeLists.inj >> ${CMAKE_USE_DIR}/CMakeLists.txt
}

src_install() {
	newbin "${BUILD_DIR}"/Telegram ${PN}
	if use packed-resources; then
		insinto /usr/share/TelegramDesktop
		doins "${BUILD_DIR}"/tresources.rcc
	fi
	newmenu lib/xdg/telegramdesktop.desktop ${PN}.desktop
	local _s
	for _s in 16 32 48 64 128 256 512; do
		newicon --size "${_s}" Telegram/Resources/art/icon${_s}.png \
			telegram.png
	done
	einstalldocs
}

src_test () {
	local _t
	for _t in "${S}"/Telegram/gyp/tests/*.test; do
		_t=$(basename "${_t}" .test)
		ebegin Running ${_t}
		"${CMAKE_BUILD_DIR}"/${_t}
		eend $?
	done
}
