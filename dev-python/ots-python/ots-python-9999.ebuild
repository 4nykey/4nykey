# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..10} )
inherit distutils-r1
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/googlefonts/${PN}.git"
	EGIT_SUBMODULES=( )
else
	MY_PV="fec97aa"
	[[ -n ${PV%%*_p*} ]] && MY_PV="v${PV}"
	SRC_URI="
		mirror://githubcl/googlefonts/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/${PN}-${MY_PV#v}"
fi

DESCRIPTION="A Python wrapper for OpenType Sanitizer"
HOMEPAGE="https://github.com/googlefonts/${PN}"

LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	>=dev-util/ots-${PV}
"
distutils_enable_tests pytest

src_prepare() {
	[[ -n ${PV%%*9999} ]] && export SETUPTOOLS_SCM_PRETEND_VERSION="${PV/_p/.post}"
	mkdir -p src/c/ots
	sed -e '/ext_modules=/d' -i setup.py
	sed \
		-e '/OTS_SANITIZE = /s:os.path.join.*:"ots-sanitize":' \
		-i src/python/ots/__init__.py
	default
}
