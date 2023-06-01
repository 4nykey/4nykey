# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/khaledhosny/${PN}.git"
	EGIT_SUBMODULES=( )
else
	MY_PV="a886e72"
	[[ -n ${PV%%*_p*} ]] && MY_PV="v${PV}"
	SRC_URI="
		mirror://githubcl/khaledhosny/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/${PN}-${MY_PV#v}"
fi
inherit meson

DESCRIPTION="An util for validating and sanitising OpenType files"
HOMEPAGE="https://github.com/khaledhosny/${PN}"

LICENSE="BSD"
SLOT="0"
IUSE="debug graphite test"

RDEPEND="
	sys-libs/zlib
	media-libs/freetype
	media-libs/woff2
	graphite? ( app-arch/lz4 )
"
DEPEND="
	${RDEPEND}
	test? ( dev-cpp/gtest )
"
DOCS=(
	README.md
	docs/{DesignDoc,HowToFix,HowToTest}.md
)
PATCHES=(
	"${FILESDIR}"/meson-gtest.diff
)

src_configure() {
	local emesonargs=(
		$(meson_use debug)
		$(meson_use graphite)
		$(meson_use test tests)
	)
	meson_src_configure
}
