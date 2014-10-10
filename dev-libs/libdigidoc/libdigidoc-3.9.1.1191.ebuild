# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
inherit cmake-utils eutils

DESCRIPTION="Library for handling digitally signed documents"
HOMEPAGE="http://installer.id.ee"
SRC_URI="https://installer.id.ee/media/sources/${P}.tar.gz"
SRC_URI="https://installer.id.ee/media/ubuntu/pool/main/${PN:0:4}/${PN}/${PN}_${PV}-ubuntu-14-04.orig.tar.gz"
RESTRICT="primaryuri"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="icu"

RDEPEND="
	dev-libs/libxml2
	dev-libs/opensc
	dev-libs/openssl
	sys-libs/zlib
	icu? ( dev-libs/icu )
"
DEPEND="
	${RDEPEND}
"

DOCS="AUTHORS README RELEASE-NOTES.txt"

src_prepare() {
	epatch "${FILESDIR}"/${PN}*.patch
}

src_configure() {
	# If prefix is /usr, sysconf needs to be /etc, not /usr/etc
	local mycmakeargs="
		${mycmakeargs}
		-DCMAKE_INSTALL_SYSCONFDIR=${EROOT}etc
	"

	cmake-utils_src_configure
}
