# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs
if [[ -z ${PV%%*9999} ]]; then
	EGIT_REPO_URI="https://github.com/${PN}/${PN}.git"
	inherit git-r3
else
	inherit vcs-snapshot
	MY_PV="980b9c5"
	[[ -n ${PV%%*_p*} ]] && MY_PV="${PV}"
	SRC_URI="
		mirror://githubcl/${PN}/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="Standards compliant, fast, secure markdown processing library in C"
HOMEPAGE="https://github.com/hoedown/hoedown"

LICENSE="ISC"
SLOT="0"
IUSE="test"

RDEPEND=""
DEPEND="
	${RDEPEND}
	test? ( app-text/htmltidy )
"

src_compile() {
	emake \
		CC=$(tc-getCC) \
		CFLAGS="${CFLAGS}"
}

src_install() {
	emake \
		PREFIX=/usr \
		LIBDIR=/usr/$(get_libdir) \
		DESTDIR="${D}" \
		install
	einstalldocs
}
