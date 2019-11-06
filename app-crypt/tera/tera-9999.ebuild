# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

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
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi
inherit cmake-utils xdg

DESCRIPTION="Time-stamping application"
HOMEPAGE="https://id.ee"

LICENSE="LGPL-2.1"
SLOT="0"
IUSE=""

RDEPEND="
	dev-qt/qtwidgets:5
	dev-qt/qtconcurrent:5
	dev-libs/libzip
	dev-libs/openssl:0
	sys-apps/pcsc-lite
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	dev-qt/linguist-tools:5
	dev-util/cmake-openeid
"

src_prepare() {
	sed \
		-e "s:\${CMAKE_SOURCE_DIR}/cmake/modules:/usr/share/cmake/openeid:" \
		-i CMakeLists.txt
	cmake-utils_src_prepare
}
