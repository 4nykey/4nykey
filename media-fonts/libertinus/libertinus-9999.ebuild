# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python{2_7,3_{5,6,7}} )
FONT_SUFFIX=otf
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/alif-type/${PN}.git"
else
	MY_PV="v${PV}"
	if [[ -z ${PV%%*_p*} ]]; then
		inherit vcs-snapshot
		MY_PV="983ab6c"
	fi
	SRC_URI="
		mirror://githubcl/alif-type/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi
inherit python-any-r1 font-r1

DESCRIPTION="A fork of the Linux Libertine and Linux Biolinum fonts"
HOMEPAGE="https://github.com/alif-type/${PN}"

LICENSE="OFL-1.1"
SLOT="0"
IUSE="+binary"

BDEPEND="
	!binary? (
		${PYTHON_DEPS}
		$(python_gen_any_dep '
			media-gfx/fontforge[python,${PYTHON_USEDEP}]
			dev-python/fonttools[${PYTHON_USEDEP}]
			dev-python/pcpp[${PYTHON_USEDEP}]
			dev-util/psautohint[${PYTHON_USEDEP}]
		')
	)
"
DOCS="*.linuxlibertine.txt"

pkg_setup() {
	use binary || python-any-r1_pkg_setup
	font-r1_pkg_setup
}

src_prepare() {
	default
	use binary || rm  -f "${S}"/*.otf
}

src_compile() {
	use binary && return
	emake \
		PY=${EPYTHON} \
		${FONT_SUFFIX}
}
