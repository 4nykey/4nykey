# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 python3_{5,6,7} )
inherit distutils-r1
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/fonttools/${PN}.git"
	REQUIRED_USE="cython"
else
	MY_PV="${PV}"
	[[ -z ${PV%%*_p*} ]] && MY_PV="${PV/_p/.post}"
	SRC_URI="
		mirror://githubcl/fonttools/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/${PN}-${MY_PV}"
fi

DESCRIPTION="A Cython wrapper for the Clipper library"
HOMEPAGE="https://github.com/fonttools/${PN}"

LICENSE="MIT"
SLOT="0"
IUSE="+cython test"

DEPEND+="
	cython? ( dev-python/cython[${PYTHON_USEDEP}] )
	test? (
		dev-python/pytest[${PYTHON_USEDEP}]
		$(python_gen_cond_dep 'dev-python/funcsigs[${PYTHON_USEDEP}]' \
			python2_7 python3_5)
	)
"

python_prepare_all() {
	if use cython; then
		touch dev
		rm -f pyclipper/pyclipper.cpp
	else
		rm -f dev
	fi
	distutils-r1_python_prepare_all
	[[ -n ${PV%%*9999} ]] && export SETUPTOOLS_SCM_PRETEND_VERSION="${MY_PV}"
}

python_test() {
	esetup.py test
}
