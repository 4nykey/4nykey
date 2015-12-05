# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/lnav/lnav-0.7.1.ebuild,v 1.1 2014/12/04 01:57:18 radhermit Exp $

EAPI=5

inherit toolchain-funcs autotools-utils
if [[ -z ${PV%%*9999} ]]; then
	EGIT_REPO_URI="https://github.com/tstack/lnav.git"
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
IUSE="unicode"

RDEPEND="
	app-arch/bzip2
	dev-db/sqlite:3
	dev-libs/libpcre[cxx]
	sys-libs/ncurses[unicode?]
	sys-libs/readline
	sys-libs/zlib
	net-misc/curl
"
DEPEND="
	${RDEPEND}
"
AUTOTOOLS_AUTORECONF="1"

src_configure() {
	local myeconfargs=(
		--disable-static
		$(use_with unicode ncursesw)
	)
	autotools-utils_src_configure
}

src_compile() {
	autotools-utils_src_compile AR="$(tc-getAR)"
}
