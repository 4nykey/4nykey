# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PN=tdesktop
CMAKE_USE_DIR="${S}/out/Release"
PYTHON_COMPAT=( python2_7 )
inherit python-any-r1 toolchain-funcs desktop xdg cmake-utils
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
	inherit vcs-snapshot
	MY_PV="9c909c8"
	[[ -n ${PV%%*_p*} ]] && MY_PV="v${PV}"
	MY_CAT="Catch2-5ca44b6"
	MY_GSL="GSL-d846fe5"
	MY_CRL="crl-52baf11"
	MY_VAR="variant-550ac2f"
	MY_XXH="xxHash-7cc9639"
	SRC_URI="
		mirror://githubcl/telegramdesktop/${MY_PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
		mirror://githubcl/telegramdesktop/${MY_CRL%-*}/tar.gz/${MY_CRL##*-}
		-> ${MY_CRL}.tar.gz
		mirror://githubcl/Microsoft/${MY_GSL%-*}/tar.gz/${MY_GSL##*-}
		-> ${MY_GSL}.tar.gz
		mirror://githubcl/mapbox/${MY_VAR%-*}/tar.gz/${MY_VAR##*-}
		-> ${MY_VAR}.tar.gz
		mirror://githubcl/Cyan4973/${MY_XXH%-*}/tar.gz/${MY_XXH##*-}
		-> ${MY_XXH}.tar.gz
		test? (
			mirror://githubcl/catchorg/${MY_CAT%-*}/tar.gz/${MY_CAT##*-}
			-> ${MY_CAT}.tar.gz
		)
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi
MY_DEB="${PN}_1.8.8-1.debian"
SRC_URI+="
	mirror://debian/pool/main/t/${PN}/${MY_DEB}.tar.xz
"

DESCRIPTION="Telegram Desktop messaging app"
HOMEPAGE="https://desktop.telegram.org"

LICENSE="GPL-3"
SLOT="0"
IUSE="gtk test +webp"

RDEPEND="
	dev-qt/qtmultimedia:5
	dev-qt/qtgui:5[xcb]
	dev-qt/qtnetwork:5
	webp? ( dev-qt/qtimageformats:5 )
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
	>=media-libs/rlottie-0.0.1_p20190927
"
DEPEND="
	${RDEPEND}
	x11-libs/libxkbcommon[static-libs]
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
}

src_prepare() {
	if [[ -n ${PV%%*9999} ]]; then
		mv "${WORKDIR}"/${MY_CRL}/* "${S}"/Telegram/ThirdParty/crl/
		mv "${WORKDIR}"/${MY_DEB} "${S}"/debian
		mv "${WORKDIR}"/${MY_GSL}/* "${S}"/Telegram/ThirdParty/GSL/
		mv "${WORKDIR}"/${MY_VAR}/* "${S}"/Telegram/ThirdParty/variant/
		mv "${WORKDIR}"/${MY_XXH}/* "${S}"/Telegram/ThirdParty/xxHash/
		use test && mv "${WORKDIR}"/${MY_CAT}/* "${S}"/Telegram/ThirdParty/Catch/
	else
		unpack ${MY_DEB}.tar.xz
	fi

	cp "${FILESDIR}"/{Packed-resources,Use-system-wide-font}.patch "${S}"/debian/patches
	rm \
		debian/patches/Modify-build-scripts.patch \
		debian/patches/Deprecated-ranges.patch \
		-f
	local _patches=(
		debian/patches
		"${FILESDIR}"/${PN}-gyp.diff
		"${FILESDIR}"/${PN}-pch.diff
		"${FILESDIR}"/${PN}-qt_functions.diff
		"${FILESDIR}"/${PN}-ui_pch.diff
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
	)
	local _f=(
		$(${_p} --cflags ${_l[@]})
		-I"${EPREFIX}"/usr/include/range/v3
	)
	local _d=(
		TDESKTOP_DISABLE_UNITY_INTEGRATION
		TDESKTOP_DISABLE_CRASH_REPORTS
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
		-Dofficial_build_target=
		-Dapi_id=${TELEGRAM_API_ID:-17349}
		-Dapi_hash=${TELEGRAM_API_HASH:-344583e45741c457fe1862106095a5eb}
		-Duse_packed_resources=1
		-Dnot_need_gtk="True"
		-Dmy_cflags="${_f[*]}"
		-Dqt_version=${_q%[-_]*}
		-Dlinux_path_qt="${EPREFIX}/usr/$(get_libdir)/qt5"
		-Dlinux_path_xkbcommon="${EPREFIX}/usr"
		-Dlinux_path_opus_include="${EPREFIX}/usr/include/opus"
		-Dminizip_loc="${EPREFIX}/usr/include/minizip"
		-Dbuild_defines="${_d:1}"
	)

	cd "${S}"/Telegram/gyp

	use test || sed -e '/\<tests\>/d' -i telegram/telegram.gypi
	sed \
		-e "s%target_name': 'tests_storage',%& 'libraries': ['crypto',],%" \
		-i tests/tests.gyp

	grep -rl 'libs_loc)/' | xargs sed -e '/<(libs_loc)\//d' -i
	sed -e '/qt_static_plugins/d' -i telegram/sources.txt
	sed \
		-e '/utils.gyp:Updater/d' \
		-e '/libtgvoip.gyp/d' \
		-e '/\<\(AL_LIBTYPE_STATIC\|minizip_loc\)\>/d' \
		-i telegram/telegram.gypi
	sed \
		-e '/\<\(qwebp\|Qt5PlatformSupport\|qtharfbuzzng\|qtpcre\)\>/d' \
		-e '/\<\(qconnmanbearer\|qgenericbearer\|qnmbearer\|xcb-static\)\>/d' \
		-e '/<(linux_lib_/d' \
		-e '/linux_glibc_wraps/d' \
		-e "s:<!@(python -c .*\(<@(qt_libs)\).*:\1',:" \
		-e '/\<qt_loc\>/s:\(/include\):/../..\1/qt5:' \
		-e "/linux_path_xkbcommon/s:\<lib\>:$(get_libdir):" \
		-e '/-static-libstdc++/d' \
		-i modules/qt.gypi
	sed \
		-e '/-\<Werror\>/d' \
		-e "/'QT_STATICPLUGIN',/d" \
		-i common/linux.gypi
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
	sed -e '/lib_\(rlottie\|lz4\)/d' -i lib_lottie.gyp

	cd "${S}"
	set -- gyp "${mygypargs[@]}" Telegram/gyp/Telegram.gyp
	einfo "${@}"
	"${@}" || die "gyp failed"

	cmake-utils_src_prepare

	cat debian/CMakeLists.inj >> ${CMAKE_USE_DIR}/CMakeLists.txt
}

src_install() {
	newbin "${BUILD_DIR}"/Telegram ${PN}
	insinto /usr/share/TelegramDesktop
	doins "${BUILD_DIR}"/tresources.rcc
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
