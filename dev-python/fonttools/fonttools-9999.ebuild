# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/fonttools/fonttools-2.4.ebuild,v 1.1 2014/05/26 08:51:17 patrick Exp $

EAPI=5
PYTHON_COMPAT=( python{2_7,3_2,3_3,3_4} )
PYTHON_REQ_USE="xml(+)"

inherit distutils-r1 git-r3

DESCRIPTION="Library for manipulating TrueType, OpenType, AFM and Type1 fonts"
HOMEPAGE="http://fonttools.sourceforge.net/"
#SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"
EGIT_REPO_URI="https://github.com/behdad/fonttools.git"

LICENSE="BSD"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="
	>=dev-python/numpy-1.0.2[${PYTHON_USEDEP}]
"
RDEPEND="
	${DEPEND}
"

DOCS=( README.md Doc/{changes.txt,install.txt} )

python_install_all() {
	dohtml Doc/documentation.html || die "dohtml failed"
	distutils-r1_python_install_all
}
