# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

MY_PN="OpenFst"
DESCRIPTION="OpenFst is a library for weighted finite-state transducers (FSTs)"
HOMEPAGE="http://www.openfst.org/"
SRC_URI="http://128.122.80.210/~openfst/twiki/pub/FST/FstDownload/${MY_PN}-beta-${PV}.tgz"
S="${WORKDIR}/${MY_PN}/fst/lib"

LICENSE=""
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND=""
RDEPEND=""

src_compile() {
	emake \
		OPT="${CXXFLAGS} -fPIC" \
		SOFLAGS="-shared -Wl,-soname=libfst.so" \
		|| die
}

src_install() {
	dolib.a libfst.a
	dolib.so libfst.so
	insinto /usr/include/fst/lib
	insopts -m0644
	doins *.h
}
