# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

if [[ ${PV} = *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/open-eid/${PN}.git"
else
	inherit vcs-snapshot
	MY_PV="${PV/_/-}"
	MY_PV="${MY_PV^^}"
	SRC_URI="
		mirror://githubcl/open-eid/${PN}/tar.gz/v${MY_PV} -> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi
inherit cmake-utils

DESCRIPTION="DigiDoc digital signature library"
HOMEPAGE="https://open-eid.github.io"

LICENSE="LGPL-2.1"
SLOT="0"
IUSE="apidocs c++0x doc test"
REQUIRED_USE="apidocs? ( doc )"

RDEPEND="
	dev-libs/libdigidoc
	dev-libs/xerces-c
	dev-libs/xml-security-c
	dev-util/cppunit
	sys-libs/zlib[minizip]
"
DEPEND="
	${RDEPEND}
	>=dev-cpp/xsd-4.0
	test? ( dev-libs/boost )
	apidocs? ( app-doc/doxygen )
	dev-util/cmake-openeid
"
DOCS=( AUTHORS README.md RELEASE-NOTES.txt )

src_prepare() {
	sed \
		-e "s:doc/${PN}:doc/${PF}:" \
		-e 's:\${CMAKE_SOURCE_DIR}/cmake/modules:/usr/share/cmake/openeid:' \
		-e 's:set_ex\(( [^ ]\+\) "$ENV{[^}]\+}" \(.*)\):set_env\1 \2:' \
		-i CMakeLists.txt
	use test || sed -i CMakeLists.txt -e '/add_subdirectory(test)/d'
	sed \
		-e 's:NOT CERTS_LOCATION:INSTALL_CERTS AND &:' \
		-e '/INSTALL_RPATH/d' \
		-i src/CMakeLists.txt
	rm -rf src/{minizip,openssl}
	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DINSTALL_DOC=$(usex doc)
		-DDISABLE_CXX11=$(usex !c++0x)
		-DCMAKE_INSTALL_SYSCONFDIR="${EROOT}etc"
	)
	cmake-utils_src_configure
}
