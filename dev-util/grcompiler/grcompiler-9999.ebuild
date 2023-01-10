# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/silnrsi/${PN}.git"
else
	MY_PV="0f3b355"
	[[ -n ${PV%%*_*} ]] && MY_PV="v${PV}"
	SRC_URI="
		mirror://githubcl/silnrsi/${PN}/tar.gz/v${PV} -> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/${PN}-${MY_PV#v}"
fi

DESCRIPTION="The SIL Graphite compiler"
HOMEPAGE="http://graphite.sil.org"

LICENSE="|| ( CPL-0.5 LGPL-2.1+ )"
SLOT="0"
IUSE=""

RDEPEND="
	dev-libs/icu:=
"
DEPEND="
	${RDEPEND}
	app-text/docbook2X
"

src_prepare() {
	sed \
		-e '/^FetchContent_Declare(/,/^endif()/d' \
		-i compiler/CMakeLists.txt
	cmake_src_prepare
}
