# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

if [[ ${PV} = *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/open-eid/${PN}.git"
else
	MY_PV="v${PV/_/-}"
	if [[ -z ${PV%%*_p*} ]]; then
		inherit vcs-snapshot
		MY_PV="a7a2547"
	fi
	MY_PV="${MY_PV/rc/RC}"
	MY_C="certs-99e63ae"
	SRC_URI="
		mirror://githubcl/open-eid/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
		mirror://githubcl/open-eid/${MY_C%-*}/tar.gz/${MY_C##*-} -> ${MY_C}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi
inherit flag-o-matic cmake

DESCRIPTION="DigiDoc digital signature library"
HOMEPAGE="https://id.ee"

LICENSE="LGPL-2.1"
SLOT="0"

IUSE="apidocs"

RDEPEND="
	dev-libs/libxml2:2
	dev-libs/openssl:0
	dev-libs/opensc
	sys-libs/zlib[minizip]
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	apidocs? ( app-doc/doxygen )
	dev-util/cmake-openeid
"
DOCS=( AUTHORS RE{ADME,LEASE-NOTES}.md )

src_prepare() {
	local PATCHES=( "${FILESDIR}"/${PN}-inc.diff )
	[[ -n ${PV%%*9999} ]] && mv "${WORKDIR}"/${MY_C}/* "${S}"/etc/certs
	sed \
		-e "/CMAKE_INSTALL_DOCDIR/s:${PN}:${PF}:" \
		-e 's:\${CMAKE_SOURCE_DIR}/cmake/modules:/usr/share/cmake/openeid:' \
		-i CMakeLists.txt
	cmake_src_prepare
	append-cppflags '-DOF=_Z_OF'
}

src_configure() {
	local mycmakeargs=(
		-DCMAKE_INSTALL_SYSCONFDIR="${EPREFIX}/etc"
		-DCMAKE_DISABLE_FIND_PACKAGE_Doxygen=$(usex !apidocs)
	)
	cmake_src_configure
}
