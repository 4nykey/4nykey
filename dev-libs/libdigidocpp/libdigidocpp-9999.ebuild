# Copyright 1999-2018 Gentoo Foundation
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
IUSE="apidocs pdf test"

RDEPEND="
	dev-libs/libdigidoc
	dev-libs/xerces-c
	dev-libs/xml-security-c
	dev-util/cppunit
	sys-libs/zlib[minizip]
	pdf? ( <app-text/podofo-0.9.5 )
"
DEPEND="
	${RDEPEND}
	>=dev-cpp/xsd-4.0
	test? ( dev-libs/boost )
	apidocs? ( app-doc/doxygen )
	dev-util/cmake-openeid
	|| (
		dev-util/xxdi
		app-editors/vim-core
	)
"
DOCS=( AUTHORS README.md RELEASE-NOTES.md )

src_prepare() {
	sed \
		-e 's:\${CMAKE_SOURCE_DIR}/cmake/modules:/usr/share/cmake/openeid:' \
		-i CMakeLists.txt
	use test || sed -i CMakeLists.txt -e '/add_subdirectory(test)/d'
	has_version app-editors/vim-core || sed \
		-e 's:xxd -i \(tslcert.\.crt\):xxdi.pl \1 >:' -i src/CMakeLists.txt
	sed \
		-e 's:XERCESC_LIBRARIES:XercesC_LIBRARIES:' -i src/CMakeLists.txt
	rm -rf src/{minizip,openssl}
	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DCMAKE_DISABLE_FIND_PACKAGE_Doxygen=$(usex !apidocs)
		-DCMAKE_DISABLE_FIND_PACKAGE_PoDoFo=$(usex !pdf)
		-DCMAKE_DISABLE_FIND_PACKAGE_SWIG=yes
		-DCMAKE_INSTALL_SYSCONFDIR="${EROOT}etc"
	)
	cmake-utils_src_configure
}
