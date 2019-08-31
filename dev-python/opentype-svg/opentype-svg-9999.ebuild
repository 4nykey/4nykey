# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{5,6,7} )
MY_PN=${PN//-/_}
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/adobe-type-tools/${PN}.git"
else
	inherit vcs-snapshot
	MY_PV="3e33e13"
	[[ -n ${PV%%*_p*} ]] && MY_PV="${PV}"
	SRC_URI="
		mirror://githubcl/adobe-type-tools/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	KEYWORDS="~amd64 ~x86"
	RESTRICT="primaryuri"
fi
inherit python-single-r1

DESCRIPTION="Scripts for making OpenType-SVG fonts"
HOMEPAGE="https://github.com/adobe-type-tools/${PN}"

LICENSE="MIT"
SLOT="0"
IUSE=""

RDEPEND="
	dev-python/fonttools[${PYTHON_USEDEP}]
"
DEPEND="
	${RDEPEND}
	${PYTHON_DEPS}
"

src_prepare() {
	default
	sed -e "/\<import\> /s:\<util\>:${MY_PN}.&:" -i *.py
}

src_install() {
	python_moduleinto ${MY_PN}
	python_domodule util
	python_doscript *.py
	einstalldocs
}
