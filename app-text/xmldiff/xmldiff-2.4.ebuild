# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8} )
DISTUTILS_USE_SETUPTOOLS="rdepend"

inherit distutils-r1

DESCRIPTION="A tool that figures out the differences between two similar XML files"
HOMEPAGE="https://github.com/Shoobx/xmldiff https://www.logilab.org/project/xmldiff"
SRC_URI="mirror://githubcl/Shoobx/${PN}/tar.gz/${PV} -> ${P}.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	dev-python/lxml[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
"
DOCS=( CHANGES.rst README.rst )
distutils_enable_tests pytest
