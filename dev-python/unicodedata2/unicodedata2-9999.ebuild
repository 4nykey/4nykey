# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{12..14} )
DISTUTILS_USE_PEP517=setuptools
DISTUTILS_EXT=1
inherit distutils-r1
MY_PV="18.0.0"
SRC_URI="
	test? (
		https://www.unicode.org/Public/${MY_PV}/ucd/NormalizationTest.txt
		-> NormalizationTest-${MY_PV}.txt
		https://www.unicode.org/Public/3.2-Update/NormalizationTest-3.2.0.txt
		https://www.unicode.org/Public/${MY_PV}/ucd/extracted/DerivedName.txt
		-> DerivedName-${MY_PV}.txt
	)
"
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/fonttools/${PN}.git"
else
	MY_PV="$(ver_rs 3 -)"
	[[ -z ${PV%%*_p*} ]] && MY_PV="45378d5"
	SRC_URI+="
		mirror://githubcl/fonttools/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64"
	S="${WORKDIR}/${PN}-${MY_PV}"
fi

DESCRIPTION="Unicodedata backport, updates"
HOMEPAGE="https://github.com/fonttools/${PN}"

LICENSE="Apache-2.0"
SLOT="0"
IUSE="test"

RDEPEND="
"
DEPEND="
	${RDEPEND}
"
distutils_enable_tests pytest

src_prepare() {
	default
	use test || return
	mkdir -p tests/data
	cp "${DISTDIR}"/*.txt tests/data
}
