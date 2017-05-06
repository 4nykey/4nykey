# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )
inherit distutils-r1
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/davelab6/${PN}.git"
else
	inherit vcs-snapshot
	MY_PV="9a13ac3"
	MY_FC="fontconfig-d162a4a"
	SRC_URI="
		mirror://githubcl/davelab6/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
		mirror://githubcl/freedesktop/${MY_FC%-*}/tar.gz/${MY_FC##*-} -> ${MY_FC}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="A tool to check font files for language/character set support"
HOMEPAGE="https://github.com/davelab6/${PN}"

LICENSE="GPL-3"
SLOT="0"
IUSE="icu"

RDEPEND="
	dev-python/lxml[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	dev-python/tabulate[${PYTHON_USEDEP}]
	dev-python/fonttools[${PYTHON_USEDEP}]
	icu? ( dev-python/pyicu[${PYTHON_USEDEP}] )
	dev-python/nose[${PYTHON_USEDEP}]
	dev-python/python-dateutil[${PYTHON_USEDEP}]
	dev-python/pyparsing[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/matplotlib[${PYTHON_USEDEP}]
"
DEPEND="
	${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
"

python_prepare_all() {
	distutils-r1_python_prepare_all
	[[ -n ${PV%%*9999} ]] && \
	mv "${WORKDIR}"/${MY_FC}/* "${S}"/fontaine/charsets/fontconfig
}
