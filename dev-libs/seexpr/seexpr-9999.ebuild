# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{2_7,3_{4,5,6}} )
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/wdas/${PN}.git"
else
	inherit vcs-snapshot
	MY_PV="db4cfca"
	[[ -n ${PV%%*_p*} ]] && MY_PV="v${PV/_beta/-beta.}"
	SRC_URI="
		mirror://githubcl/wdas/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi
inherit python-single-r1 cmake-utils

DESCRIPTION="An embeddable expression evaluation engine"
HOMEPAGE="https://www.disneyanimation.com/technology/seexpr.html"

LICENSE="Apache-2.0"
SLOT="2"
IUSE="-llvm python"
REQUIRED_USE="
	python? ( ${PYTHON_REQUIRED_USE} )
"

RDEPEND="
	python? (
		${PYTHON_DEPS}
		dev-libs/boost[python,${PYTHON_USEDEP}]
	)
	llvm? ( >=sys-devel/llvm-3.8:* )
	dev-python/PyQt4[X,${PYTHON_USEDEP}]
"
DEPEND="
	${RDEPEND}
	sys-devel/flex
	virtual/yacc
"

src_prepare() {
	cmake-utils_src_prepare
	sed \
		-e '/from PyQt4 import pyqtconfig/d' \
		-e 's:pyqtconfig:sipconfig:' \
		-e "s:pkg_cfg\['pyqt_sip_dir'\]:os.path.join(pkg_cfg['default_sip_dir'],'PyQt4'):" \
		-i src/build/build-info
	sed \
		-e '/PYTHON_VERSION_MAJOR LESS/s:3:9999:' \
		-e '/BOOST_PYTHON_LIBNAME/s:\<boost_python\>:&-${PYTHON_VERSION_MINOR}.${PYTHON_VERSION_MINOR}:' \
		-i CMakeLists.txt
}

src_configure() {
	local mycmakeargs=(
		-DENABLE_LLVM_BACKEND=$(usex llvm)
		$(usex llvm '' '-DSEEXPR_ENABLE_LLVM_BACKEND=0')
		-DUSE_PYTHON=$(usex python)
		-DSEEXPR_HTML_DOC_PATH="share/doc/${PF}/html"
		-DPYTHON_EXECUTABLE=${PYTHON}
		-DBOOST_PYTHON_LIBNAME=
	)
	cmake-utils_src_configure
}
