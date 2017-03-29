# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils eutils flag-o-matic
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/open-eid/${PN}.git"
else
	inherit vcs-snapshot
	MY_PV="${PV/_/-}"
	MY_PV="${MY_PV/rc/RC}"
	SRC_URI="
		mirror://githubcl/open-eid/${PN}/tar.gz/v${MY_PV} -> ${P}.tar.gz
	"
	# submodules not included in github releases
	MY_SC="smartcardpp-ed6bc67"
	SRC_URI="${SRC_URI}
		mirror://githubcl/open-eid/${MY_SC%-*}/tar.gz/${MY_SC##*-}
		-> ${MY_SC}.tar.gz
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
	dev-libs/openssl:0
	sys-apps/pcsc-lite
"
DEPEND="
	${RDEPEND}
	dev-util/cmake-openeid
"

DOCS=( AUTHORS README.md RELEASE-NOTES.txt )

src_prepare() {
	default
	[[ -n ${PV%%*9999} ]] && mv "${WORKDIR}"/${MY_SC}/* "${S}"/${MY_SC%-*}/
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
	local _s
	for _s in esteid-pkcs11{,-onepin}.so;
		do dosym ../${_s} /usr/$(get_libdir)/pkcs11/${_s}
	done
}
