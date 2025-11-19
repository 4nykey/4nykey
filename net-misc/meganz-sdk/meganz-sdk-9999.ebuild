# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake flag-o-matic
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/${PN%-*}/${PN#*-}.git"
	SLOT="0/99999"
else
	MY_PV="61013ee"
	[[ -n ${PV%%*_p*} ]] && MY_PV="v${PV}"
	SRC_URI="
		mirror://githubcl/${PN%-*}/${PN#*-}/tar.gz/${MY_PV}
		-> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64"
	S="${WORKDIR}/sdk-${MY_PV#v}"
	SLOT="0/$(( $(ver_cut 1)*10000 + $(ver_cut 2)*100 + $(ver_cut 3) ))"
fi

DESCRIPTION="MEGA C++ SDK"
HOMEPAGE="https://github.com/meganz/sdk"

LICENSE="BSD-2"
IUSE="debug examples ffmpeg freeimage fuse inotify libuv mediainfo qt raw readline +sqlite test"
REQUIRED_USE="
	examples? ( readline sqlite )
"
# tests require working mega.nz account and login details provided via $MEGA_EMAIL and $MEGA_PWD
# and they are dectructive
RESTRICT+=" test"

RDEPEND="
	dev-libs/crypto++:=
	dev-libs/libpcre:3[cxx]
	dev-libs/openssl:0
	net-misc/curl
	sqlite? ( dev-db/sqlite:3 )
	examples? (
		sys-libs/readline:0
	)
	fuse? ( sys-fs/fuse:0 )
	freeimage? ( media-libs/freeimage )
	libuv? ( dev-libs/libuv )
	dev-libs/libsodium
	mediainfo? ( media-libs/libmediainfo )
	ffmpeg? ( media-video/ffmpeg )
	raw? ( media-libs/libraw )
	readline? ( sys-libs/readline )
"
DEPEND="
	${RDEPEND}
	test? ( dev-cpp/gtest )
"
PATCHES=(
	"${FILESDIR}"/cmake.diff
)

src_configure() {
	use debug || append-cppflags '-DNDEBUG'
	local mycmakeargs=(
		-DSDKLIB_STANDALONE=yes
		-DENABLE_LOG_PERFORMANCE=no
		-DENABLE_SDKLIB_EXAMPLES=$(usex examples)
		-DENABLE_SDKLIB_TESTS=$(usex test)
		-DENABLE_SDKLIB_WERROR=no
		-DENABLE_QT_BINDINGS=$(usex qt)
		-DHAVE_LIBRAW=$(usex qt $(usex raw))
		-DENABLE_MEDIA_FILE_METADATA=$(usex mediainfo)
		-DUSE_FREEIMAGE=$(usex freeimage)
		-DENABLE_ISOLATED_GFX=$(usex freeimage)
		-DHAVE_FFMPEG=$(usex ffmpeg)
		-DUSE_LIBUV=$(usex libuv)
		-DUSE_PDFIUM=no
		-DUSE_READLINE=$(usex readline)
		-DWITH_FUSE=$(usex fuse)
		-DUSE_SQLITE=$(usex sqlite)
	)
	cmake_src_configure
}

src_test() {
	export MEGA_EMAIL MEGA_PWD MEGA_EMAIL_AUX="${MEGA_EMAIL}" MEGA_PWD_AUX="${MEGA_PWD}"
	default
}

src_install() {
	cmake_src_install
	rm -rf "${ED}"/usr/include/mega/{osx,win32,wincurl,wp8}

	insinto /usr/share/mega/cmake
	doins cmake/modules/*.cmake
}
