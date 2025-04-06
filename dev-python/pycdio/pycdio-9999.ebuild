# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} )

inherit distutils-r1
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/rocky/${PN}.git"
else
	MY_PV="806c6a2"
	[[ -n ${PV%%*_p*} ]] && MY_PV="${PV}"
	SRC_URI="
		mirror://githubcl/rocky/${PN}/tar.gz/${MY_PV}
		-> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64"
	S="${WORKDIR}/${PN}-${MY_PV}"
fi

DESCRIPTION="Python OO interface to libcdio (CD Input and Control library)"
HOMEPAGE="
	https://savannah.gnu.org/projects/libcdio/
	https://github.com/rocky/pycdio/
	https://pypi.org/project/pycdio/
"

LICENSE="GPL-3+"
SLOT="0"
IUSE="examples"

DEPEND="
	>=dev-libs/libcdio-2.0.0
"
RDEPEND="
	${DEPEND}
"
BDEPEND="
	dev-lang/swig
"

distutils_enable_tests pytest

python_prepare_all() {
	# Remove obsolete sys.path and adjust 'data' paths in examples.
	sed -i \
		-e "s:^sys.path.insert.*::" \
		-e "s:\.\./data:./data:g" \
		example/*.py || die
	distutils-r1_python_prepare_all
}

python_test() {
	epytest -opython_files='test-*.py'
}

python_install_all() {
	distutils-r1_python_install_all
	if use examples; then
		docinto examples
		dodoc -r example/.
		docompress -x /usr/share/doc/${PF}/examples
	fi
}
