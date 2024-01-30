# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic qmake-utils autotools
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/${PN%-*}/${PN#*-}.git"
	SLOT="0/99999"
else
	MY_PV="1ef93bb"
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
IUSE="examples ffmpeg freeimage fuse inotify libuv mediainfo qt raw +sqlite test"
REQUIRED_USE="
	examples? ( sqlite )
	fuse? ( examples )
"
# tests require a working mega.nz account and login details provided via $MEGA_EMAIL and $MEGA_PWD
RESTRICT+=" test"

RDEPEND="
	dev-libs/crypto++:=
	sys-libs/zlib
	dev-libs/libpcre:3[cxx]
	dev-libs/openssl:0
	net-dns/c-ares
	net-misc/curl
	sqlite? ( dev-db/sqlite:3 )
	examples? (
		sys-libs/readline:0
		fuse? ( sys-fs/fuse:0 )
	)
	freeimage? ( media-libs/freeimage )
	libuv? ( dev-libs/libuv )
	dev-libs/libsodium
	mediainfo? ( media-libs/libmediainfo )
	ffmpeg? ( media-video/ffmpeg )
	raw? ( media-libs/libraw )
"
DEPEND="
	${RDEPEND}
	test? ( dev-cpp/gtest )
"

src_prepare() {
	default

	if use qt; then
		sed \
		-e "/^MEGASDK_BASE_PATH =/ s:=.*:= ${EPREFIX}/usr/:" \
		-e 's:VPATH += \$\$MEGASDK_BASE_PATH:&/include/mega:' \
		-e '/INCLUDEPATH +=/ s:+:-:' \
		-e '/SOURCES += src\// s:+:-:' \
		-e '/^unix:!macx {/,/^}/d' \
		-e '/QMAKE_CXXFLAGS +=/d' \
		-i bindings/qt/sdk.pri
	printf 'unix {
	LIBS += -lmega
	INCLUDEPATH += $$MEGASDK_BASE_PATH/include/mega \
	$$MEGASDK_BASE_PATH/include/mega/posix \
	$$MEGASDK_BASE_PATH/include/mega/bindings/qt
}' >> bindings/qt/sdk.pri
	local _b=include/mega/bindings/qt
	mkdir -p ${_b}
	cp -a bindings/qt/*.{h,cpp,pri} ${_b}
	fi

	use test && sed \
		-e 's:\$(GTEST_DIR)/lib/lib\([^ ]\+\)\.la:-l\1:g' \
		-e 's: tests/tool_purge_account::' \
		-i tests/include.am

	eautoreconf
}

src_configure() {
	local myeconfargs=(
		$(use_enable inotify)
		$(use_with libuv)
		$(use_with sqlite)
		$(use_enable examples)
		$(use_enable test tests)
		$(use_with freeimage)
		$(use_with fuse)
		$(use_with mediainfo libmediainfo)
		$(use_with ffmpeg)
		$(use_with raw libraw)
	)
	use test && myeconfargs+=(
		--with-gtest="${EPREFIX}/usr"
	)
	econf "${myeconfargs[@]}"
}

src_test() {
	export MEGA_EMAIL MEGA_PWD MEGA_EMAIL_AUX="${MEGA_EMAIL}" MEGA_PWD_AUX="${MEGA_PWD}"
	default
}

src_install() {
	default
	doheader -r include/mega
	find "${ED}" -type f -name '*.la' -delete
	rm -rf "${ED}"/usr/include/mega/{osx,win32,wincurl,wp8}

	insinto /usr/share/mega
	doins -r m4
}
