# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/open-eid/${PN}.git"
else
	inherit vcs-snapshot
	MY_PV="${PV/_/-}"
	MY_PV="${MY_PV^^}"
	SRC_URI="
		mirror://githubcl/open-eid/${PN}/tar.gz/v${MY_PV} -> ${P}.tar.gz
	"
	# submodules not included in github releases
	MY_QC="qt-common-719160d"
	SRC_URI="${SRC_URI}
		mirror://githubcl/open-eid/${MY_QC%-*}/tar.gz/${MY_QC##*-} -> ${MY_QC}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi
inherit cmake-utils

DESCRIPTION="Smart card manager UI application"
HOMEPAGE="https://open-eid.github.io"

LICENSE="LGPL-2.1"
SLOT="0"
IUSE=""

RDEPEND="
	sys-apps/pcsc-lite
	dev-libs/opensc
	dev-qt/linguist-tools:5
	dev-qt/qtwidgets:5
"
DEPEND="
	${RDEPEND}
	dev-util/cmake-openeid
"
DOCS=( AUTHORS README.md RELEASE-NOTES.txt )

src_prepare() {
	[[ -n ${PV%%*9999} ]] && mv "${WORKDIR}"/${MY_QC}/* "${S}"/common/
	sed \
		-e "s:doc/${PN}:doc/${PF}:" \
		-e 's:\${CMAKE_SOURCE_DIR}/cmake/modules:/usr/share/cmake/openeid:' \
		-i CMakeLists.txt
	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=()
	[[ -n ${PV%%*9999} ]] && mycmakeargs=( -DBREAKPAD='' )
	cmake-utils_src_configure
}
