# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..10} )
inherit distutils-r1
MY_NI="ninja-1.11.1"
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/scikit-build/${PN}.git"
else
	SRC_URI="
		mirror://githubcl/scikit-build/${PN}/tar.gz/${PV} -> ${P}.tar.gz
		mirror://githubcl/ninja-build/ninja/tar.gz/v${MY_NI#*-} -> ${MY_NI}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="A tool to build Ninja Python wheels"
HOMEPAGE="https://github.com/scikit-build/${PN}"

LICENSE="Apache-2.0"
SLOT="0"
IUSE=""

RDEPEND="
	dev-util/ninja
"
DEPEND="
	${RDEPEND}
"

python_prepare_all() {
	sed \
		-e '/import setup/ s:skbuild:setuptools:' \
		-e '/entry_points={/,/},/d' \
		-i setup.py
	sed \
		-e "/^DATA = os.path.join/ s:=.*:= '${EPREFIX}/usr':" \
		-i src/ninja/__init__.py
	cp ../${MY_NI}/misc/ninja_syntax.py src/ninja
	distutils-r1_python_prepare_all
}
