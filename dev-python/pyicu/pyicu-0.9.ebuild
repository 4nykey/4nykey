# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit distutils

MY_PN="PyICU"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="a Python extension wrapping IBM's International components for
Unicode C++ Library"
HOMEPAGE="http://pyicu.osafoundation.org/"
SRC_URI="http://pypi.python.org/packages/source/P/${MY_PN}/${MY_P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

DEPEND="doc? ( dev-python/epydoc )"
RDEPEND=">=dev-libs/icu-3.6"

S="${WORKDIR}/${MY_P}"

DOCS="CHANGES CREDITS README"

src_compile() {
	if use doc; then
		epydoc --html --verbose --url="${HOMEPAGE}" --name="${MY_P}" "${MY_PN}".py \
		|| die "Making the docs failed!"
	fi
	distutils_src_compile
}

src_test() {
	PYTHONPATH="$(ls -d build/lib.*)" ${python} setup.py test \
		|| die "Tests failed to complete!"
}

src_install() {
	if use doc; then
		dohtml -r html/* || die "Installing the docs failed!"
	fi
	distutils_src_install
}
