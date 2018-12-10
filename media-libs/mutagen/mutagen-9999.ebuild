# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 python3_{4,5,6,7} pypy{,3} )
inherit eutils distutils-r1
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/quodlibet/picard.git"
else
	inherit vcs-snapshot
	MY_PV="release-${PV}"
	SRC_URI="
		mirror://githubcl/quodlibet/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	KEYWORDS="~amd64 ~x86"
	RESTRICT="primaryuri"
fi

DESCRIPTION="Python module for handling audio metadata"
HOMEPAGE="https://mutagen.readthedocs.io"

LICENSE="GPL-2"
SLOT="0"
IUSE="doc test"

RDEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
"
DEPEND="
	${RDEPEND}
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )
	test? (
		dev-python/hypothesis[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}]
	)
"

python_compile_all() {
	use doc && emake -C docs
}

python_test() {
	esetup.py test --no-quality
}

python_install_all() {
	local DOCS=( NEWS README.rst )
	use doc && local HTML_DOCS=( docs/_build/. )
	distutils-r1_python_install_all
}
