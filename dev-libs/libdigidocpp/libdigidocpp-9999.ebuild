# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

if [[ ${PV} = *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/open-eid/${PN}.git"
else
	MY_PV="${PV/_/-}"
	MY_PV="${MY_PV^^}"
	[[ -z ${PV%%*_p*} ]] && MY_PV="8c95639"
	SRC_URI="
		mirror://githubcl/open-eid/${PN}/tar.gz/v${MY_PV} -> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/${PN}-${MY_PV#v}"
fi
inherit cmake

DESCRIPTION="DigiDoc digital signature library"
HOMEPAGE="https://id.ee"

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
"
BDEPEND="
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
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DCMAKE_DISABLE_FIND_PACKAGE_Doxygen=$(usex !apidocs)
		-DCMAKE_DISABLE_FIND_PACKAGE_PoDoFo=$(usex !pdf)
		-DCMAKE_DISABLE_FIND_PACKAGE_SWIG=yes
		-DCMAKE_INSTALL_SYSCONFDIR="${EROOT}etc"
	)
	cmake_src_configure
}

src_test() {
	local myctestargs=( -j1 )
	cmake_src_test
}
