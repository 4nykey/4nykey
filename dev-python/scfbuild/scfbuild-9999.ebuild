# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..13} )
DISTUTILS_USE_PEP517=setuptools
DISTUTILS_SINGLE_IMPL=1
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/eosrei/${PN}.git"
else
	MY_PV="1d782f4"
	SRC_URI="
		mirror://githubcl/eosrei/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64"
	S="${WORKDIR}/${PN}-${MY_PV#v}"
fi
inherit distutils-r1

DESCRIPTION="Create SVG in OpenType color fonts from a set of SVG source files"
HOMEPAGE="https://github.com/eosrei/scfbuild"

LICENSE="GPL-3"
SLOT="0"
IUSE=""

DEPEND="
	$(python_gen_cond_dep '
		dev-python/fonttools[${PYTHON_USEDEP}]
		media-gfx/fontforge[python,${PYTHON_SINGLE_USEDEP}]
		dev-python/pyyaml[${PYTHON_USEDEP}]
	')
"
RDEPEND="${DEPEND}"

pkg_setup() {
	python_setup
}

python_prepare_all() {
	distutils-r1_python_prepare_all
	[[ -e "${S}"/setup.py ]] && return
	printf '#!%s\nfrom distutils.core import setup\nsetup(
	name="%s",version=%s,description="%s",url="%s",license="%s",
	packages=["%s", "%s"],scripts=["%s"])\n' \
	"${PYTHON}" \
	"${PN}" \
	$(awk '/__version__/ {print $3}' scfbuild/__init__.py) \
	"${DESCRIPTION}" \
	"${HOMEPAGE}" \
	"${LICENSE}" \
	"${PN}" "${PN}.constants"\
	"bin/${PN}" \
	> "${S}"/setup.py
}
