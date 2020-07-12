# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8} )
inherit distutils-r1
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/kkroening/${PN}.git"
else
	MY_PV="78fb6cf"
	[[ -n ${PV%%*_p*} ]] && MY_PV="${PV}"
	SRC_URI="
		mirror://githubcl/kkroening/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/${PN}-${MY_PV}"
fi

DESCRIPTION="Python bindings for FFmpeg"
HOMEPAGE="https://github.com/kkroening/${PN}"

LICENSE="Apache-2.0"
SLOT="0"
IUSE="test"

DEPEND="
"
RDEPEND="
	${DEPEND}
	virtual/ffmpeg
"
BDEPEND="
	test? (
		dev-python/pytest-mock[${PYTHON_USEDEP}]
		virtual/ffmpeg
	)
"
distutils_enable_tests pytest

python_prepare_all() {
	sed -e '/\<pytest-runner\>/d' -i setup.py
	distutils-r1_python_prepare_all
}
