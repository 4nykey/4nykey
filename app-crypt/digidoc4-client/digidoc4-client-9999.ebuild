# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="DigiDoc4-Client"
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/open-eid/${MY_PN}.git"
else
	MY_PV="${PV^^}"
	MY_PV="v${MY_PV/_/-}"
	[[ -z ${PV%%*_p*} ]] && MY_PV="a4da0d3"
	MY_QC="qt-common-8e4034f"
	SRC_URI="${SRC_URI}
		mirror://githubcl/open-eid/${MY_PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
		mirror://githubcl/open-eid/${MY_QC%-*}/tar.gz/${MY_QC##*-} -> ${MY_QC}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/${MY_PN}-${MY_PV#v}"
fi
inherit cmake xdg

DESCRIPTION="An application for digitally signing and encrypting documents"
HOMEPAGE="https://open-eid.github.io"

LICENSE="LGPL-2.1 Nokia-Qt-LGPL-Exception-1.1"
SLOT="0"
IUSE="nautilus qt6"

DEPEND="
	>=dev-libs/libdigidocpp-4
	sys-apps/pcsc-lite
	net-nds/openldap
	dev-libs/openssl:=
	qt6? (
		dev-qt/qtbase:6=[gui,network,widgets]
		dev-qt/qt5compat:6=
		dev-qt/qtsvg:6=
	)
	!qt6? (
		dev-qt/qtwidgets:5=
		dev-qt/qtprintsupport:5=
		dev-qt/qtsvg:5=
		dev-qt/qtnetwork:5=
	)
"
RDEPEND="
	${DEPEND}
	dev-libs/opensc[pcsc-lite]
	nautilus? ( gnome-base/nautilus )
"
BDEPEND="
	qt6? (
		dev-qt/qttools:6[linguist]
	)
	!qt6? (
		dev-qt/linguist-tools:5
	)
	>=dev-util/cmake-openeid-0_p20240821
"
DOCS=( {README,RELEASE-NOTES}.md )

src_prepare() {
	if [[ -n ${PV%%*9999} ]]; then
		mv "${WORKDIR}"/${MY_QC}/* "${S}"/common/
	fi
	sed \
		-e "s:doc/${PN}:doc/${PF}:" \
		-e "s:\${CMAKE_SOURCE_DIR}/cmake/modules:/usr/share/cmake/openeid:" \
		-i CMakeLists.txt
	use qt6 && sed -e '/QT NAMES/s: Qt5::' -i CMakeLists.txt
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DENABLE_KDE=no
		-DENABLE_NAUTILUS_EXTENSION=$(usex nautilus)
	)
	cmake_src_configure
}
