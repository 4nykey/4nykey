# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

if [[ ${PV} = *9999* ]]; then
	VCS_ECLASS="subversion"
	ESVN_REPO_URI="https://svn.eesti.ee/projektid/idkaart_public/branches/${PV%.*}/${PN}"
	KEYWORDS=""
else
	SRC_URI="https://installer.id.ee/media/sources/${P}.tar.gz"
	SRC_URI="https://installer.id.ee/media/ubuntu/pool/main/${PN:0:1}/${PN}/${PN}_${PV}-ubuntu-14-04.orig.tar.gz"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi
inherit cmake-utils eutils ${VCS_ECLASS}

DESCRIPTION="Estonian ID card digital signature desktop tools"
HOMEPAGE="http://installer.id.ee"

LICENSE="LGPL-2.1 Nokia-Qt-LGPL-Exception-1.1"
SLOT="0"
IUSE="c++0x +qt5"

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

src_configure() {
	local mycmakeargs="
		${mycmakeargs}
		$(cmake-utils_useno c++0x DISABLE_CXX11)
	"
	cmake-utils_src_configure
}

