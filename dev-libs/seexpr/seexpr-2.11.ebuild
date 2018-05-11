# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/wdas/${PN}.git"
else
	inherit vcs-snapshot
	MY_PV="db4cfca"
	[[ -n ${PV%%*_p*} ]] && MY_PV="v${PV}"
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
SLOT="0"
IUSE="apidocs"
REQUIRED_USE="
	${PYTHON_REQUIRED_USE}
"

RDEPEND="
	${PYTHON_DEPS}
	dev-python/PyQt4[X,${PYTHON_USEDEP}]
"
DEPEND="
	${RDEPEND}
	apidocs? ( app-doc/doxygen )
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
	sed -e "s:\(share/doc/\)SeExpr:\1${PF}/html:" -i src/doc/CMakeLists.txt
}

src_configure() {
	local mycmakeargs=(
		-DCMAKE_DISABLE_FIND_PACKAGE_Doxygen=$(usex !apidocs)
	)
	cmake-utils_src_configure
}
