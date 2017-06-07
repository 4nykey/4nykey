# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 python3_{4,5,6} )

inherit toolchain-funcs cmake-utils distutils-r1
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/google/${PN}.git"
else
	inherit vcs-snapshot
	SRC_URI="mirror://githubcl/google/${PN}/tar.gz/v${PV} -> ${P}.tar.gz"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="Generic-purpose lossless compression algorithm"
HOMEPAGE="https://github.com/google/${PN}"

LICENSE="Apache-2.0"
SLOT="0"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}"

DOCS="CONTRIBUTING.md README.md"

src_configure() {
	distutils-r1_src_configure
	cmake-utils_src_configure
}

src_compile() {
	distutils-r1_src_compile
	cmake-utils_src_compile
}

src_install() {
	distutils-r1_src_install
	cmake-utils_src_install
}
