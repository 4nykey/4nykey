# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8} )
FONT_SUFFIX=otf
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/alerque/${PN}.git"
else
	MY_PV="983ab6c"
	[[ -n ${PV%%*_p*} ]] && MY_PV="v${PV}"
	SRC_URI="
		mirror://githubcl/alerque/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/${PN}-${MY_PV#v}"
fi
inherit python-any-r1 font-r1

DESCRIPTION="A fork of the Linux Libertine and Linux Biolinum fonts"
HOMEPAGE="https://github.com/alerque/${PN}"

LICENSE="OFL-1.1"
SLOT="0"
IUSE="+binary"

BDEPEND="
	!binary? (
		${PYTHON_DEPS}
		$(python_gen_any_dep '
			>=dev-python/fonttools-4.10.2[ufo(-),${PYTHON_USEDEP}]
			dev-python/ufo2ft[cffsubr(-),${PYTHON_USEDEP}]
			dev-python/pcpp[${PYTHON_USEDEP}]
			dev-python/sfdLib[${PYTHON_USEDEP}]
		')
		dev-util/psautohint
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
