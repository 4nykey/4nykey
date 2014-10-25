# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

if [[ ${PV} = *9999* ]]; then
	VCS_ECLASS="subversion"
	ESVN_REPO_URI="https://svn.eesti.ee/projektid/idkaart_public/branches/${PV%.*}/${PN}"
else
	SRC_URI="https://installer.id.ee/media/sources/${P}.tar.gz"
	SRC_URI="https://installer.id.ee/media/ubuntu/pool/main/${PN:0:4}/${PN}/${PN}_${PV}-ubuntu-14-04.tar.gz"
	RESTRICT="primaryuri"
	S="${WORKDIR}/${PN}"
	KEYWORDS="~amd64 ~x86"
fi
inherit cmake-utils eutils ${VCS_ECLASS}

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
	>=dev-cpp/xsd-3.2.0
	test? ( dev-libs/boost )
	apidocs? ( app-doc/doxygen )
"
RDEPEND="
	${RDEPEND}
	app-misc/esteidcerts
"

DOCS="AUTHORS README RELEASE-NOTES.txt"

src_prepare() {
	sed -i CMakeLists.txt -e "s:doc/${PN}:doc/${PF}:"
	use test || sed -i CMakeLists.txt -e '/add_subdirectory(test)/d'
	# We use another package (app-misc/esteidcerts) to install root certs
	sed \
		-e 's:NOT CERTS_LOCATION:INSTALL_CERTS AND &:' \
		-i src/CMakeLists.txt
	cmake-utils_src_prepare
}

src_configure() {
	# If prefix is /usr, sysconf needs to be /etc, not /usr/etc
	local mycmakeargs="
		${mycmakeargs}
		$(cmake-utils_use doc INSTALL_DOC)
		$(cmake-utils_useno c++0x DISABLE_CXX11)
		-DCMAKE_INSTALL_SYSCONFDIR=${EROOT}etc
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
