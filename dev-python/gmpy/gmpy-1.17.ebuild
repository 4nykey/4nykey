# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{2_7,3_4,3_5} )

inherit distutils-r1 vcs-snapshot

DESCRIPTION="Python bindings for GMP library"
HOMEPAGE="https://github.com/aleaxit/${PN}"
SRC_URI="mirror://githubcl/aleaxit/${PN}/tar.gz/${PN}_${PV//./_} -> ${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-libs/gmp:0"
DEPEND="${RDEPEND}"

DOCS=( doc/gmpydoc.txt )
HTML_DOCS=( doc/index.html )

python_test() {
	if $(python_is_python3); then
		pushd test3 > /dev/null
	else
		pushd test > /dev/null
	fi
	sed \
		-e 's:_test():_test(chat=True):g' \
		-i gmpy_test.py || die
	"${EPYTHON}" gmpy_test.py || return 1
	popd > /dev/null
}
