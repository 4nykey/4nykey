# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python2_7 )
DISTUTILS_SINGLE_IMPL=1
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/eosrei/${PN}.git"
else
	inherit vcs-snapshot
	MY_PV="4fd834f"
	SRC_URI="
		mirror://githubcl/eosrei/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi
inherit distutils-r1

DESCRIPTION="Create SVG in OpenType color fonts from a set of SVG source files"
HOMEPAGE="https://github.com/eosrei/scfbuild"

LICENSE="GPL-3"
SLOT="0"
IUSE=""

DEPEND="
	>=dev-python/fonttools-2.5[${PYTHON_USEDEP}]
	media-gfx/fontforge[python,${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]
"
RDEPEND="${DEPEND}"
PATCHES=(
	"${FILESDIR}"/${PN}-no_fonttools_version_check.diff
)

pkg_setup() {
	python_setup
}

src_prepare() {
	default
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
