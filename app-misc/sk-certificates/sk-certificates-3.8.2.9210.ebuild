# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

MY_PN="esteidcerts"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Estonian root certificates for PKI"
HOMEPAGE="http://installer.id.ee"
SRC_URI="https://installer.id.ee/media/sources/${MY_P}.tar.gz"
SRC_URI="https://installer.id.ee/media/ubuntu/pool/main/${MY_PN:0:1}/${MY_PN}/${MY_PN}_${PV}-ubuntu-14-04.tar.gz"
RESTRICT="primaryuri"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

S="${WORKDIR}/${MY_P}"

src_install() {
	doins -r usr
}
