# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit cmake-utils eutils flag-o-matic unpacker
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/open-eid/${PN}.git"
else
	inherit vcs-snapshot
	MY_PV="${PV/_/-}"
	MY_PV="${MY_PV/rc/RC}"
	SRC_URI="
		mirror://github/open-eid/${PN}/archive/v${MY_PV}.tar.gz -> ${P}.tar.gz
	"
	# submodules not included in github releases
	MY_SC="smartcardpp-9a506a0d69f00d5970cf5c213bc23547687104ab"
	SRC_URI="${SRC_URI}
		mirror://github/open-eid/${MY_SC%-*}/archive/${MY_SC##*-}.zip -> ${MY_SC}.zip
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="EstEID PKCS11 Module"
HOMEPAGE="http://id.ee"

LICENSE="LGPL-2.1"
SLOT="0"
IUSE=""

RDEPEND="
	dev-libs/openssl
	sys-apps/pcsc-lite
"
DEPEND="
	${RDEPEND}
	$(unpacker_src_uri_depends)
	dev-util/cmake-openeid
"

DOCS="AUTHORS README* RELEASE-NOTES.txt"

src_prepare() {
	if [[ -n ${PV%%*9999} ]]; then
		mv "${WORKDIR}"/${MY_SC}/* "${S}"/${MY_SC%-*}/
	fi
	sed \
		-e 's:\${CMAKE_SOURCE_DIR}/cmake/modules:/usr/share/cmake/openeid:' \
		-e '/Add_Custom_Command.*POST_BUILD/d' \
		-e '/add_subdirectory(googlemock)/d' \
		-e '/ies(runUnitTests /d' \
		-e 's: runUnitTests::' \
		-ne '/add_executable(runUnitTests/,/)/!p' \
		-i CMakeLists.txt
}

src_install() {
	cmake-utils_src_install
	for x in esteid-pkcs11{,-onepin}.so;
		do dosym ../${x} /usr/$(get_libdir)/pkcs11/${x}
	done
}
