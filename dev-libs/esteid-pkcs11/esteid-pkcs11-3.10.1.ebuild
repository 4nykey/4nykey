# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit cmake-utils eutils flag-o-matic
MY_PV="${PV/_/-}"
MY_PV="${MY_PV/rc/RC}"
MY_P="${PN}-${MY_PV}"
if [[ ${PV} = *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/open-eid/${PN}.git"
else
	SRC_URI="
		https://github.com/open-eid/${PN}/releases/download/v${MY_PV}/${MY_P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="EstEID PKCS11 Module"
HOMEPAGE="http://id.ee"

LICENSE="LGPL-2.1"
SLOT="0"
IUSE="test"

DEPEND="
	dev-libs/openssl
	sys-apps/pcsc-lite
"
RDEPEND="
	${DEPEND}
	test? ( dev-util/gcovr )
"
S="${WORKDIR}/${MY_P}"

DOCS="AUTHORS README* RELEASE-NOTES.txt"

src_prepare() {
	if use test; then
		append-cxxflags '-DGTEST_LANG_CXX11=0'
	else
		sed \
			-e '/Add_Custom_Command.*POST_BUILD/d' \
			-e '/add_subdirectory(googlemock)/d' \
			-e '/ies(runUnitTests /d' \
			-e 's: runUnitTests::' \
			-ne '/add_executable(runUnitTests/,/)/!p' \
			-i CMakeLists.txt
	fi
}

src_install() {
	cmake-utils_src_install
	for x in esteid-pkcs11{,-onepin}.so;
		do dosym ../${x} /usr/$(get_libdir)/pkcs11/${x}
	done
}
