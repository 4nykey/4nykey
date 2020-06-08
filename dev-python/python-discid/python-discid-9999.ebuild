# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7} )

inherit distutils-r1
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/JonnyJD/${PN}.git"
else
	MY_PV="v${PV}"
	if [[ -z ${PV%%*_p*} ]]; then
		inherit vcs-snapshot
		MY_PV="fd714ad"
	fi
	SRC_URI="
		mirror://githubcl/JonnyJD/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="Python bindings for libdiscid"
HOMEPAGE="https://python-discid.readthedocs.io"

LICENSE="LGPL-3+"
SLOT="0"
IUSE="doc"

RDEPEND="
	media-libs/libdiscid
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )
"

python_compile_all() {
	if use doc; then
		cd doc || die
		sphinx-build . _build/html || die
		HTML_DOCS=( doc/_build/html/. )
	fi
}

python_test() {
	esetup.py test
}
