# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..13} )
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/rougier/${PN}.git"
else
	MY_PV="v${PV}"
	[[ -z ${PV%%*_p*} ]] && MY_PV="f7344d3"
	SRC_URI="
		mirror://githubcl/rougier/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64"
	S="${WORKDIR}/${PN}-${MY_PV#v}"
fi

DESCRIPTION="Python bindings for the freetype library"
HOMEPAGE="https://github.com/rougier/${PN}"

LICENSE="BSD"
SLOT="0"
IUSE="test"

RDEPEND="
	media-libs/freetype:2
"
DEPEND="
	${RDEPEND}
"
distutils_enable_tests pytest

pkg_setup() {
	[[ -n ${PV%%*9999} ]] && export SETUPTOOLS_SCM_PRETEND_VERSION="${PV%_*}"
}

python_test() {
	epytest tests
}
