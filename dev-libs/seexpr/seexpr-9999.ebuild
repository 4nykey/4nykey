# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{2_7,3_{4,5,6}} )
LLVM_MAX_SLOT=4
SLOT="2"
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/wdas/${PN}.git"
else
	inherit vcs-snapshot
	MY_PV="db4cfca"
	[[ -n ${PV%%*_p*} ]] && MY_PV="v${SLOT}-${PV}"
	SRC_URI="
		mirror://githubcl/wdas/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi
inherit python-single-r1 llvm cmake-utils

DESCRIPTION="An embeddable expression evaluation engine"
HOMEPAGE="https://www.disneyanimation.com/technology/seexpr.html"

LICENSE="Apache-2.0"
IUSE="apidocs llvm python test"
REQUIRED_USE="
	python? ( ${PYTHON_REQUIRED_USE} )
"

RDEPEND="
	python? (
		${PYTHON_DEPS}
		dev-libs/boost[python,${PYTHON_USEDEP}]
	)
	llvm? (
		>sys-devel/llvm-4:=
		<sys-devel/llvm-$((LLVM_MAX_SLOT+1)):=
	)
	dev-python/PyQt5[widgets,${PYTHON_USEDEP}]
"
DEPEND="
	${RDEPEND}
	apidocs? ( app-doc/doxygen )
	test? ( dev-cpp/gtest )
	sys-devel/flex
	virtual/yacc
"

src_prepare() {
	cmake-utils_src_prepare
	sed \
		-e '/from PyQt4 import pyqtconfig/d' \
		-e 's:pyqtconfig:sipconfig:' \
		-e "s:pkg_cfg\['pyqt_sip_dir'\]:os.path.join(pkg_cfg['default_sip_dir'],'PyQt5'):" \
		-i src/build/build-info
	sed \
		-e '/PYTHON_VERSION_MAJOR LESS/s:3:9999:' \
		-e '/BOOST_PYTHON_LIBNAME/s:\<boost_python\>:&-${PYTHON_VERSION_MINOR}.${PYTHON_VERSION_MINOR}:' \
		-e '/set(LLVM_LIB/d' \
		-e 's:-msse4.1::' \
		-i CMakeLists.txt
	sed -e "s:\(share/doc/\)SeExpr2:\1${PF}/html:" -i src/doc/CMakeLists.txt
}

src_configure() {
	local mycmakeargs=(
		-DENABLE_QT5=yes
		-DENABLE_LLVM_BACKEND=$(usex llvm)
		$(usex llvm '' '-DSEEXPR_ENABLE_LLVM_BACKEND=0')
		-DUSE_PYTHON=$(usex python)
		-DPYTHON_EXECUTABLE=${PYTHON}
		-DBOOST_PYTHON_LIBNAME=
		-DCMAKE_DISABLE_FIND_PACKAGE_Doxygen=$(usex !apidocs)
	)
	if use llvm; then
		local _lc=$(get_llvm_prefix "${LLVM_MAX_SLOT}")
		mycmakeargs+=(
			-DLLVM_DIR="${_lc}/$(get_libdir)/cmake/llvm"
			-DLLVM_LIB="$(${_lc}/bin/llvm-config --libs)"
		)
	fi
	cmake-utils_src_configure
}
