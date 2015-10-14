# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit cmake-utils eutils
if [[ ${PV} = *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/open-eid/${PN}.git"
else
	inherit vcs-snapshot
	MY_PV="${PV/_/-}"
	MY_PV="${MY_PV/rc/RC}"
	SRC_URI="
		mirror://github/open-eid/${PN}/archive/v${MY_PV}.tar.gz -> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="DigiDoc digital signature library"
HOMEPAGE="http://id.ee"

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
RDEPEND="
	${RDEPEND}
	app-misc/esteidcerts
"

DOCS="AUTHORS README* RELEASE-NOTES.txt"

src_prepare() {
	sed \
		-e "s:doc/${PN}:doc/${PF}:" \
		-e 's:\${CMAKE_SOURCE_DIR}/cmake/modules:/usr/share/cmake/openeid:' \
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
	# If prefix is /usr, sysconf needs to be /etc, not /usr/etc
	local mycmakeargs="
		${mycmakeargs}
		$(cmake-utils_use doc INSTALL_DOC)
		$(cmake-utils_useno c++0x DISABLE_CXX11)
		-DCMAKE_INSTALL_SYSCONFDIR=/etc
	"
	cmake-utils_src_configure
}

pkg_postinst() {
	if use doc; then
		einfo 'You might want to alter ecompress exclude mask'
		einfo 'by adding the following line to make.conf:'
		einfo 'PORTAGE_COMPRESS_EXCLUDE_SUFFIXES="${PORTAGE_COMPRESS_EXCLUDE_SUFFIXES} zip docx"'
	fi
}
