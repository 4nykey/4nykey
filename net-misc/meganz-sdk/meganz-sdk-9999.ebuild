# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit flag-o-matic qmake-utils autotools db-use
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/${PN%-*}/${PN#*-}.git"
else
	inherit vcs-snapshot
	MY_PV="b72f462"
	[[ -n ${PV%%*_p*} ]] && MY_PV="v${PV}"
	SRC_URI="
		mirror://githubcl/${PN%-*}/${PN#*-}/tar.gz/${MY_PV}
		-> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="MEGA C++ SDK"
HOMEPAGE="https://github.com/meganz/sdk"

LICENSE="BSD-2"
SLOT="0"
IUSE="examples freeimage fuse hardened inotify libuv mediainfo qt +sqlite"
REQUIRED_USE="
	examples? ( sqlite )
	fuse? ( examples )
"

DEPEND="
	dev-libs/crypto++
	sys-libs/zlib
	dev-libs/libpcre:3[cxx]
	dev-libs/openssl:0
	net-dns/c-ares
	net-misc/curl
	sqlite? ( dev-db/sqlite:3 )
	!sqlite? ( sys-libs/db:*[cxx] )
	examples? (
		sys-libs/readline:0
		fuse? ( sys-fs/fuse:0 )
	)
	freeimage? ( media-libs/freeimage )
	libuv? ( dev-libs/libuv )
	dev-libs/libsodium
	mediainfo? ( media-libs/libmediainfo )
"
RDEPEND="
	${DEPEND}
"

pkg_setup() {
	use sqlite || append-cppflags "-I$(db_includedir)"
}

src_prepare() {
	default
	use qt && sed \
		-e '/SOURCES += src\// s:+:-:' \
		-e '/!exists.*config.h/ s:!::' \
		-e 's:-lsqlite3 -lrt:-lmega &:' \
		-i bindings/qt/sdk.pri
	eautoreconf
}

src_configure() {
	local myeconfargs=(
		--enable-chat
		$(use_enable inotify)
		$(use_enable hardened gcc-hardening)
		$(use_with libuv)
		$(use_with !sqlite db)
		$(use_with sqlite)
		$(use_enable examples)
		$(use_with freeimage)
		$(use_with fuse)
		$(use_with mediainfo libmediainfo)
	)
	econf "${myeconfargs[@]}"
}

src_install() {
	default
	doheader -r include/mega

	use qt || return
	insinto /usr/share/${PN}/bindings/qt
	doins bindings/qt/*.{h,cpp,pri}
}
