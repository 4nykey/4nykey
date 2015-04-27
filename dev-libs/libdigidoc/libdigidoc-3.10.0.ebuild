# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit cmake-utils eutils
if [[ ${PV} = *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/open-eid/${PN}.git"
else
	SRC_URI="https://github.com/open-eid/${PN}/releases/download/v${PV}/${P}.tar.gz"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="DigiDoc digital signature library"
HOMEPAGE="http://id.ee"

LICENSE="LGPL-2.1"
SLOT="0"

IUSE="apidocs doc"
REQUIRED_USE="apidocs? ( doc )"

RDEPEND="
	dev-libs/libxml2:2
	dev-libs/openssl:0
	dev-libs/opensc
	sys-libs/zlib[minizip]
"
DEPEND="
	${RDEPEND}
	apidocs? ( app-doc/doxygen )
"

PATCHES=( "${FILESDIR}"/${PN}*.patch )
DOCS="AUTHORS README* RELEASE-NOTES.txt"

src_prepare() {
	sed \
		-e "s:doc/${PN}:doc/${PF}:" \
		-i CMakeLists.txt
	sed \
		-e '/INSTALL_RPATH/d' \
		-i libdigidoc/CMakeLists.txt
	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs="
		${mycmakeargs}
		$(cmake-utils_use doc INSTALL_DOC)
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
