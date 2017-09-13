# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/khaledhosny/${PN}.git"
	EGIT_SUBMODULES=( third_party/googletest )
else
	inherit vcs-snapshot
	MY_PV="a9fb129"
	[[ -n ${PV%%*_p*} ]] && MY_PV="v${PV}"
	MY_T="googletest-5e7fd50"
	SRC_URI="
		mirror://githubcl/khaledhosny/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
		test? ( mirror://githubcl/google/${MY_T%-*}/tar.gz/${MY_T##*-}
			-> ${MY_T}.tar.gz )
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi
inherit autotools flag-o-matic

DESCRIPTION="An util for validating and sanitising OpenType files"
HOMEPAGE="https://github.com/khaledhosny/${PN}"

LICENSE="BSD"
SLOT="0"
IUSE="graphite test"

DEPEND="
	sys-libs/zlib
	media-libs/freetype
	media-libs/woff2
	graphite? ( app-arch/lz4 )
"
RDEPEND="
	${DEPEND}
"
DOCS=(
	README
	docs/DesignDoc.md
	docs/HowToFix.md
	docs/HowToTest.md
)
PATCHES=( "${FILESDIR}"/${PN}-systemlibs.diff )

src_prepare() {
	default
	if use test; then
		mv "${WORKDIR}"/${MY_T}/* third_party/${MY_T%-*}
	else
		sed -e '/noinst_PROGRAMS [+]*=/d' -i Makefile.am
	fi
	eautoreconf
	append-cppflags "-I${EROOT}usr/include/woff2 -I${EROOT}usr/include/brotli"
}

src_configure() {
	econf \
		$(use_enable graphite)
}
