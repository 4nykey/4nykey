# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/fonttools/fonttools-2.4.ebuild,v 1.1 2014/05/26 08:51:17 patrick Exp $

EAPI=5
PYTHON_COMPAT=( python{2_7,3_2,3_3,3_4} )
PYTHON_REQ_USE="xml(+)"

inherit distutils-r1
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/behdad/${PN}.git"
else
	SRC_URI="https://codeload.github.com/behdad/${PN}/tar.gz/${PV} -> ${P}.tar.gz"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="Library for manipulating TrueType, OpenType, AFM and Type1 fonts"
HOMEPAGE="http://fonttools.sourceforge.net/"

LICENSE="BSD"
SLOT="0"
IUSE=""

DEPEND="
	>=dev-python/numpy-1.0.2[${PYTHON_USEDEP}]
"
RDEPEND="
	${DEPEND}
"

DOCS=( README.md Doc/{changes.txt,install.txt} )
