# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{4,5,6,7} )
inherit distutils-r1
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/greginvm/${PN}.git"
	REQUIRED_USE="cython"
else
	inherit vcs-snapshot
	SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.zip"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
	DEPEND="app-arch/unzip"
fi

DESCRIPTION="A Cython wrapper for the Clipper library"
HOMEPAGE="https://github.com/greginvm/${PN}"

LICENSE="MIT"
SLOT="0"
IUSE="cython test"

DEPEND+="
	cython? ( dev-python/cython[${PYTHON_USEDEP}] )
	test? (
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/funcsigs[python_targets_python2_7?,python_targets_python3_4?,python_targets_python3_5?]
	)
"

python_prepare_all() {
	if use cython; then
		touch "${S}"/dev
	else
		rm -f "${S}"/dev
	fi
	local _v="${PV%_p*}"
	[[ -z ${PV%%*9999} ]] && _v="$(git describe --tags)"
	sed \
		-e '/setuptools_scm/d' \
		-e "s:use_scm_version=True:version=\"${_v}\":" \
		-i "${S}"/setup.py
	distutils-r1_python_prepare_all
}

python_test() {
	esetup.py test
}
