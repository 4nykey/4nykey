# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"
inherit cmake-utils

DESCRIPTION="Smart card manager UI application"
HOMEPAGE="http://id.ee"
SRC_URI="https://installer.id.ee/media/sources/${P}.tar.gz"
SRC_URI="https://installer.id.ee/media/ubuntu/pool/main/${PN:0:1}/${PN}/${PN}_${PV}-ubuntu-14-04.tar.gz"
RESTRICT="primaryuri"
S="${WORKDIR}/${PN}"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+qt5"

RDEPEND="
	sys-apps/pcsc-lite
	dev-libs/opensc
	qt5? (
		dev-qt/linguist-tools:5
		dev-qt/qtwidgets:5
		dev-qt/qtnetwork:5
	)
	!qt5? (
		dev-qt/qtcore:4[ssl]
		dev-qt/qtgui:4
		dev-qt/qtwebkit:4
	)
"
DEPEND="
	${RDEPEND}
"

src_prepare() {
	use qt5 || sed '/find_package.*Qt5Widgets/d' -i CMakeLists.txt
}
