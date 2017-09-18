# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/c4dm/${PN}.git"
else
	inherit vcs-snapshot
	MY_PV="4d15479"
	[[ -n ${PV%%*_p*} ]] && MY_PV="v${PV}"
	SRC_URI="mirror://githubcl/c4dm/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi
inherit toolchain-funcs

DESCRIPTION="A C++ library for audio analysis"
HOMEPAGE="https://code.soundsoftware.ac.uk/projects/${PN}"

LICENSE="GPL-2"
SLOT="0"
IUSE=""

RDEPEND="
	sci-libs/clapack
	virtual/cblas
"
DEPEND="
	${RDEPEND}
"

src_prepare() {
	tc-export CC CXX AR RANLIB
	sed -e 's,:=,+=,; s,-O3,,' build/linux/Makefile.linux64 > Makefile
	sed \
		-e 's,-Iext/clapack.*/include,,' \
		-e 's,C\(LAPACK\|BLAS\)_SRC := ,&#,' \
		-i build/general/Makefile.inc
	sed -e 's,clapack\.h,clapack/&,' -i hmm/hmm.c
	default
}

src_install() {
	dolib.a lib${PN}.a
	mkdir -p ${PN}
	find base dsp ext/kissfft hmm maths thread -type f -name '*.h'|xargs tar c|\
		tar x -C ${PN}
	doheader -r ${PN}
	einstalldocs
}
