# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/open-eid/${PN}.git"
else
	inherit vcs-snapshot
	MY_PV="${PV/_/-}"
	MY_PV="v${MY_PV^^}"
	[[ -z ${PV%%*_p*} ]] && MY_PV="868e824"
	SRC_URI="
		mirror://githubcl/open-eid/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	# submodules not included in github releases
	MY_QC="qt-common-a4eedae"
	SRC_URI="${SRC_URI}
		mirror://githubcl/open-eid/${MY_QC%-*}/tar.gz/${MY_QC##*-} -> ${MY_QC}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi
inherit cmake-utils xdg

DESCRIPTION="Smart card manager UI application"
HOMEPAGE="https://open-eid.github.io"

LICENSE="LGPL-2.1"
SLOT="0"
IUSE=""

RDEPEND="
	sys-apps/pcsc-lite
	dev-libs/opensc
	dev-qt/qtwidgets:5
"
DEPEND="
	${RDEPEND}
	dev-qt/linguist-tools:5
	dev-util/cmake-openeid
"
DOCS=( AUTHORS {README,RELEASE-NOTES}.md )

src_prepare() {
	[[ -n ${PV%%*9999} ]] && mv "${WORKDIR}"/${MY_QC}/* "${S}"/common/
	sed \
		-e "s:doc/${PN}:doc/${PF}:" \
		-e "s:\${CMAKE_SOURCE_DIR}/cmake/modules:${EROOT}usr/share/cmake/openeid:" \
		-e 's:find_package( Qt5.*:&\nfind_package( Threads ):' \
		-i CMakeLists.txt
	cmake-utils_src_prepare
}
