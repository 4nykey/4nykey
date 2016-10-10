# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

if [[ -z ${PV%%*9999} ]]; then
	inherit mercurial
	EHG_REPO_URI="https://code.soundsoftware.ac.uk/hg/${PN}"
else
	SRC_URI="https://code.soundsoftware.ac.uk/attachments/download/1582/${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi
inherit toolchain-funcs flag-o-matic

DESCRIPTION="A C++ library for audio analysis"
HOMEPAGE="https://code.soundsoftware.ac.uk/projects/${PN}"

LICENSE="GPL-2"
SLOT="0"
IUSE=""

DEPEND="
	sci-libs/clapack
"
RDEPEND="${DEPEND}"
PATCHES=(
)

pkg_setup() {
	append-cppflags "-DUSE_PTHREADS -fPIC -I${EROOT}/usr/include/clapack"
}

src_compile() {
	emake \
		CXX=$(tc-getCXX) \
		CC=$(tc-getCC) \
		AR=$(tc-getAR) \
		RANLIB=$(tc-getRANLIB) \
		-f "${S}"/build/general/Makefile.inc
}

src_install() {
	dolib.a "${S}"/lib${PN}.a
	insinto /usr/include/${PN}
	find base dsp ext maths thread -type f -name '*.h' | xargs tar c | \
		tar x -C "${ED}"/usr/include/${PN} || die
	default
}
