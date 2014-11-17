# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"
inherit cmake-utils
if [[ ${PV} = *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/open-eid/${PN}.git"
else
	SRC_URI="https://installer.id.ee/media/sources/${P}.tar.gz"
	SRC_URI="https://installer.id.ee/media/ubuntu/pool/main/${PN:0:1}/${PN}/${PN}_${PV}-ubuntu-14-04.tar.gz"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/${PN}"
fi


DESCRIPTION="Smart card manager UI application"
HOMEPAGE="http://id.ee"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="c++0x +qt5"

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

src_configure() {
	local mycmakeargs="
		${mycmakeargs}
		$(cmake-utils_useno c++0x DISABLE_CXX11)
		$(cmake-utils_use_find_package qt5 Qt5Widgets)
	"
	cmake-utils_src_configure
}

