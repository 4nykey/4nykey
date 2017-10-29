# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )
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
SLOT="0"
IUSE="python"
REQUIRED_USE="
	python? ( ${PYTHON_REQUIRED_USE} )
"

RDEPEND="
	python? (
		${PYTHON_DEPS}
		dev-libs/boost[python,${PYTHON_USEDEP}]
	)
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
}

python_configure() {
	cmake-utils_src_configure
}
