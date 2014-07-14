# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"
inherit cmake-utils

DESCRIPTION="Digidoc client"
HOMEPAGE="http://installer.id.ee"
SRC_URI="https://installer.id.ee/media/sources/${P}.tar.gz"
RESTRICT="primaryuri"
S="${WORKDIR}/${PN}"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="qt5"

DEPEND="
	dev-libs/libdigidocpp
	sys-apps/pcsc-lite
	dev-libs/opensc
	qt5? (
		dev-qt/linguist-tools:5
		dev-qt/qtwidgets:5
		dev-qt/qtnetwork:5
		dev-qt/qtprintsupport:5
	)
	!qt5? (
		dev-qt/qtcore:4[ssl]
		dev-qt/qtgui:4
		dev-qt/qtwebkit:4
	)
	net-nds/openldap
"
RDEPEND="
	${DEPEND}
	app-crypt/qesteidutil
"

src_prepare() {
	use qt5 || sed '/find_package.*Qt5Widgets/d' -i CMakeLists.txt
}
