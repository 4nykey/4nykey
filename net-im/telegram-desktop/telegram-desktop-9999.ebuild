# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PN=tdesktop
if [[ -z ${PV%%*9999} ]]; then
	EGIT_REPO_URI="https://github.com/telegramdesktop/${MY_PN}.git"
	EGIT_BRANCH="dev"
	EGIT_SUBMODULES=(
		'*'
		'-Telegram/ThirdParty/GSL'
		'-Telegram/ThirdParty/expected'
		'-Telegram/ThirdParty/libdbusmenu-qt'
		'-Telegram/ThirdParty/libtgvoip'
		'-Telegram/ThirdParty/lz4'
		'-Telegram/ThirdParty/rlottie'
		'-Telegram/ThirdParty/variant'
		'-Telegram/ThirdParty/xxHash'
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
MY_DEB="${PN}-patches-793f2bd"
SRC_URI+="
	mirror://githubcl/4nykey/${MY_DEB%-*}/tar.gz/${MY_DEB##*-} -> ${MY_DEB}.tar.gz
"
#CMAKE_USE_DIR="${S}/out/Release"
PYTHON_COMPAT=( python2_7 )
inherit toolchain-funcs flag-o-matic desktop xdg cmake

DESCRIPTION="Telegram Desktop messaging app"
HOMEPAGE="https://desktop.telegram.org"

LICENSE="GPL-3"
SLOT="0"
IUSE="-crashreporter dbus gtk spell test"

RDEPEND="
	dev-qt/qtmultimedia:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtimageformats:5
	dev-qt/qtprintsupport:5
	dev-qt/qtwidgets:5[gtk?]
	dbus? ( dev-libs/libdbusmenu-qt )
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
	gtk? ( x11-libs/gtk+:3[X] )
	>=media-libs/libtgvoip-2.4.4_p20200118
	media-libs/rlottie
	x11-libs/libxkbcommon
	spell? ( app-text/enchant:0 )
	dev-libs/xxhash
"
DEPEND="
	${RDEPEND}
	>=dev-cpp/range-v3-0.10
	dev-cpp/expected
	dev-cpp/ms-gsl
	dev-cpp/variant
	crashreporter? ( dev-libs/breakpad )
"
RDEPEND="
	${RDEPEND}
	media-fonts/open-sans
"
BDEPEND="
	virtual/pkgconfig
"

pkg_setup() {
	EGIT_SUBMODULES+=( $(usex test '' '-Telegram/ThirdParty/Catch') )
}

src_prepare() {
	unpack ${MY_DEB}.tar.gz
	mv ${MY_DEB}/debian .
	rm -rf Telegram/ThirdParty/{libtgvoip,lz4,minizip,rlottie}

	local PATCHES=(
		debian/patches
		"${FILESDIR}"/${PN}-cmake.diff
		"${FILESDIR}"/${PN}-breakpad.diff
	)
	[[ -e "${FILESDIR}"/${P}.diff ]] && PATCHES+=( "${FILESDIR}"/${P}.diff )

	cmake_src_prepare

	grep -rl 'usr/local' --include=CMakeLists.txt | xargs \
		sed -e 's:/usr/local:/usr:' -i
	sed \
		-e '/qt_static_plugins\.cpp/d' \
		-e 's:third_party_loc}/minizip:Qt5Core_INCLUDE_DIRS}:' \
		-i Telegram/CMakeLists.txt
	sed \
		-e 's:\<Debug\>:Gentoo:' \
		-e 's:-Werror::' \
		-i cmake/options_linux.cmake
	sed \
		-e '/LINK_SEARCH_START_STATIC/s:1:0:' \
		-i cmake/init_target.cmake
}

src_configure() {
	local mycmakeargs=(
		-DDESKTOP_APP_USE_PACKAGED=yes
		-DDESKTOP_APP_USE_PACKAGED_FONTS=yes
		-DDESKTOP_APP_LOTTIE_USE_CACHE=no
		-DDESKTOP_APP_DISABLE_CRASH_REPORTS=$(usex !crashreporter)
		-DDESKTOP_APP_DISABLE_SPELLCHECK=$(usex !spell)
		-DTDESKTOP_DISABLE_GTK_INTEGRATION=$(usex !gtk)
		-DTDESKTOP_FORCE_GTK_FILE_DIALOG=$(usex gtk)
		-DTDESKTOP_DISABLE_DBUS_INTEGRATION=$(usex !dbus)
		-DTDESKTOP_DISABLE_DESKTOP_FILE_GENERATION=yes
		-DTDESKTOP_LAUNCHER_BASENAME=${PN}
	)
	if [[ -z ${TELEGRAM_API_ID} ]] || [[ -z ${TELEGRAM_API_HASH} ]]; then
		mycmakeargs+=( -DTDESKTOP_API_TEST=yes )
	fi

	cmake_src_configure
}
