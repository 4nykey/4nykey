# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{4,5,6} )
DISTUTILS_OPTIONAL="1"

inherit distutils-r1 cmake-utils
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

LICENSE="MIT python? ( Apache-2.0 )"
SLOT="0"
IUSE="python"

RDEPEND="python? ( ${PYTHON_DEPS} )"
DEPEND="${RDEPEND}"

DOCS=( {CONTRIBUTING,README}.md )
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

src_prepare() {
	sed -e '/^set(CMAKE_SKIP_BUILD_RPATH/,/^endif()/d' -i CMakeLists.txt
	cmake-utils_src_prepare
	use python && distutils-r1_src_prepare
}

src_configure() {
	cmake-utils_src_configure
	use python && distutils-r1_src_configure
}

src_compile() {
	cmake-utils_src_compile
	use python && distutils-r1_src_compile
}

python_test(){
	esetup.py test || die
}

src_test() {
	cmake-utils_src_test
	use python && distutils-r1_src_test
}

src_install() {
	cmake-utils_src_install
	use python && distutils-r1_src_install
}
