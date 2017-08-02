# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs flag-o-matic
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/google/${PN}.git"
	EGIT_SUBMODULES=( )
else
	inherit vcs-snapshot
	MY_PV="36e6555"
	SRC_URI="mirror://githubcl/google/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="A library and utils for Web Open Font Format 2.0"
HOMEPAGE="https://github.com/google/${PN}"

LICENSE="Apache-2.0"
SLOT="0"
IUSE=""

RDEPEND="
	app-arch/brotli
"
DEPEND="
	${RDEPEND}
	virtual/pkgconfig
"

DOCS="CONTRIBUTING.md README.md"
PATCHES=( "${FILESDIR}"/${PN}-makefile.diff )

src_prepare() {
	default
	mkdir -p ${PN}
	mv src/*.h ${PN}/
	append-cxxflags "-I${EROOT}usr/include/brotli -I${PN}"
}

src_compile() {
	tc-export CXX AR
	emake \
		BROTLI=. BROTLIOBJ= ENCOBJ= DECOBJ= COMMONOBJ= \
		LIBS="$($(tc-getPKG_CONFIG) libbrotlienc libbrotlidec --libs)"
}

src_install() {
	dobin ${PN}_*
	dolib.a lib${PN}.a
	doheader -r ${PN}
	einstalldocs
}
