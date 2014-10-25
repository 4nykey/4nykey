# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

DESCRIPTION="Estonian ID card certificates"
HOMEPAGE="http://id.ee"
SRC_URI="https://installer.id.ee/media/sources/${P}.tar.gz"
SRC_URI="https://installer.id.ee/media/ubuntu/pool/main/${PN:0:1}/${PN}/${PN}_${PV}-ubuntu-14-04.tar.gz"
RESTRICT="primaryuri"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="
	${DEPEND}
	!app-misc/sk-certificates
"

src_install() {
	doins -r usr
}
