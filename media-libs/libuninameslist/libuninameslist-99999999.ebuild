# Copyright 2004-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_OPTIONAL=true
PYTHON_COMPAT=( python{2_7,3_{6,7}} )

inherit distutils-r1
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/fontforge/${PN}"
else
	MY_PV="${PV}"
	if [[ -z ${PV%%*_p*} ]]; then
		inherit vcs-snapshot
		MY_PV="366bc41"
	fi
	SRC_URI="
		mirror://githubcl/fontforge/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	KEYWORDS="~amd64 ~x86"
	RESTRICT="primaryuri"
fi
inherit autotools

DESCRIPTION=" A library of Unicode names and annotation data"
HOMEPAGE="https://github.com/fontforge/${PN}"

LICENSE="BSD"
SLOT="0"
IUSE="python static-libs"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

RDEPEND="
"
DEPEND="
	${RDEPEND}
"

python_compile() {
	cd py
	distutils-r1_python_compile
}

python_install() {
	cd py
	distutils-r1_python_install
}

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	local myeconfargs=(
		$(use_enable static-libs static)
	)
	econf "${myeconfargs[@]}"
}

src_compile() {
	default
	use python && distutils-r1_src_compile
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete
	use python && distutils-r1_src_install
}
