# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )
inherit distutils-r1
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/googlei18n/${PN}.git"
else
	inherit vcs-snapshot
	MY_PV="68e2621"
	SRC_URI="
		mirror://githubcl/googlei18n/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="A python package for maintaining the Noto Fonts project"
HOMEPAGE="https://github.com/googlei18n/nototools"

LICENSE="Apache-2.0"
SLOT="0"
IUSE=""

DEPEND="
	dev-python/fonttools
"
RDEPEND="${DEPEND}"

pkg_setup() {
	python_setup
	python_export PYTHON_SITEDIR
}

src_install() {
	distutils-r1_src_install
	insinto /usr/share/${PN}
	doins -r third_party
	dosym /usr/share/${PN}/third_party ${PYTHON_SITEDIR}/third_party
}
