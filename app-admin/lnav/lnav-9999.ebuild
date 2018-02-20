# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs autotools
if [[ -z ${PV%%*9999} ]]; then
	EGIT_REPO_URI="https://github.com/tstack/${PN}.git"
	inherit git-r3
else
	inherit vcs-snapshot
	SRC_URI="
		mirror://githubcl/tstack/${PN}/tar.gz/v${PV} -> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="A curses-based tool for viewing and analyzing log files"
HOMEPAGE="http://lnav.org"

LICENSE="BSD-2"
SLOT="0"
IUSE="doc unicode"

RDEPEND="
	app-arch/bzip2
	dev-db/sqlite:3
	dev-libs/libpcre[cxx]
	sys-libs/ncurses:0[unicode?]
	sys-libs/readline:0
	sys-libs/zlib
	net-misc/curl
"
DEPEND="
	${RDEPEND}
	doc? ( dev-python/sphinx )
"

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	local myeconfargs=(
		--disable-static
		$(use_with unicode ncursesw)
	)
	econf "${myeconfargs[@]}"
}

src_compile() {
	emake AR="$(tc-getAR)"
	use doc && emake -C docs html
}

src_install() {
	local DOCS=(
		AUTHORS NEWS README
		$(usex doc docs/build/html '')
	)
	default
}
