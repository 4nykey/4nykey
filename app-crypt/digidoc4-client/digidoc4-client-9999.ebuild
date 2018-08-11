# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/open-eid/${PN}.git"
else
	inherit vcs-snapshot
	MY_PV="${PV^^}"
	MY_PV="v${MY_PV/_/-}"
	[[ -z ${PV%%*_p*} ]] && MY_PV="a4da0d3"
	MY_QC="qt-common-096c451"
	MY_EX="digidoc-extensions-79a7ba4"
	SRC_URI="${SRC_URI}
		mirror://githubcl/open-eid/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
		mirror://githubcl/open-eid/${MY_QC%-*}/tar.gz/${MY_QC##*-} -> ${MY_QC}.tar.gz
		mirror://githubcl/open-eid/${MY_EX%-*}/tar.gz/${MY_EX##*-} -> ${MY_EX}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi
inherit cmake-utils xdg

DESCRIPTION="An application for digitally signing and encrypting documents"
HOMEPAGE="https://open-eid.github.io"

LICENSE="LGPL-2.1 Nokia-Qt-LGPL-Exception-1.1"
SLOT="0"
IUSE="nautilus"

DEPEND="
	dev-libs/libdigidocpp
	sys-apps/pcsc-lite
	dev-libs/opensc
	dev-qt/qtwidgets:5
	dev-qt/qtprintsupport:5
	dev-qt/qtsvg:5
"
RDEPEND="
	${DEPEND}
	nautilus? ( gnome-base/nautilus )
	!app-crypt/qdigidoc
"
DEPEND="
	${DEPEND}
	dev-qt/linguist-tools:5
	dev-util/cmake-openeid
"
DOCS=( {CONTRIBUTING,README,RELEASE-NOTES}.md )

src_prepare() {
	if [[ -n ${PV%%*9999} ]]; then
		mv "${WORKDIR}"/${MY_QC}/* "${S}"/common/
		mv "${WORKDIR}"/${MY_EX}/* "${S}"/extensions/
	fi
	sed \
		-e "s:doc/${PN}:doc/${PF}:" \
		-e "s:\${CMAKE_SOURCE_DIR}/cmake/modules:${EROOT}/usr/share/cmake/openeid:" \
		-i CMakeLists.txt
	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DENABLE_KDE=no
		-DENABLE_NAUTILUS_EXTENSION=$(usex nautilus)
	)
	cmake-utils_src_configure
}
