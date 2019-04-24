# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/khaledhosny/${PN}.git"
	EGIT_SUBMODULES=( )
else
	inherit vcs-snapshot
	MY_PV="a886e72"
	[[ -n ${PV%%*_p*} ]] && MY_PV="v${PV}"
	SRC_URI="
		mirror://githubcl/khaledhosny/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi
inherit meson

DESCRIPTION="An util for validating and sanitising OpenType files"
HOMEPAGE="https://github.com/khaledhosny/${PN}"

LICENSE="BSD"
SLOT="0"
IUSE="debug graphite test variations"

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

src_prepare() {
	local PATCHES=( "${FILESDIR}"/meson-5295.diff )
	default
	sed \
		-e '/third_party\/\(woff2\|zlib\|lz4\|brotli\|googletest\)/d' \
		-e '/lib\(brotli\|woff2\|lz4\) = library(/,/^[ ]*)/d' \
		-e "s:ots_libs = \[.*:libbrotli=dependency('libbrotlidec')\nlibwoff2=dependency('libwoff2dec')\n&:" \
		-e "s:ots_libs += \[\(liblz4\)\]:\1 = dependency('\1')\n&:" \
		-e 's:zlib = dependency.*:&\nots_libs += [zlib]:' \
		-e '/link_with: ots_libs,/d' \
		-e '/dependencies: /s:zlib,$:ots_libs,:' \
		-e "s%\('gtest', \).*%\1main: true)%" \
		-i meson.build
	sed -e 's:fc-list:false:' -i tests/test_good_fonts.sh
	use test || sed \
		-e '/test_good_fonts = /,/^[ ]*)/d' \
		-e '/gtest = dependency/,//d' \
		-i meson.build
}

src_configure() {
	local emesonargs=(
		$(meson_use debug)
		$(meson_use graphite)
		$(meson_use variations)
	)
	meson_src_configure
}
