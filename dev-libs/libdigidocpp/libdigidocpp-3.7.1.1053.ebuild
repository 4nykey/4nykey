# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
inherit cmake-utils eutils

DESCRIPTION="Library for creating and validating BDoc and DDoc containers"
HOMEPAGE="http://installer.id.ee"
SRC_URI="https://installer.id.ee/media/sources/${P}.tar.gz"
RESTRICT="primaryuri"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

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
	dev-lang/swig
"
RDEPEND="
	${RDEPEND}
	>=app-misc/sk-certificates-${PV%.*}
"

DOCS="AUTHORS"

src_prepare() {
	sed -i src/io/ZipSerialize.cpp \
		-e 's:\(#include\) "../\(minizip/.\+\.h\)":\1 <\2\>:'
	sed -i src/CMakeLists.txt \
		-e '/set_target_properties.*minizip/d'
	# We use another package (app-misc/sk-certificates) to install root certs
	cd "${S}"
	rm -r src/minizip etc/certs/*
}

src_configure() {
	# If prefix is /usr, sysconf needs to be /etc, not /usr/etc
	local mycmakeargs="
		${mycmakeargs}
		-DCMAKE_INSTALL_SYSCONFDIR=${EROOT}etc
	"

	cmake-utils_src_configure
}
