# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..13} )
DISTUTILS_USE_PEP517=maturin
DISTUTILS_EXT=1
CRATES="
	autocfg@1.3.0
	cfg-if@1.0.0
	heck@0.5.0
	indoc@2.0.5
	libc@0.2.155
	memoffset@0.9.1
	once_cell@1.19.0
	portable-atomic@1.6.0
	proc-macro2@1.0.86
	pyo3@0.22.1
	pyo3-build-config@0.22.1
	pyo3-ffi@0.22.1
	pyo3-macros@0.22.1
	pyo3-macros-backend@0.22.1
	quote@1.0.36
	syn@2.0.70
	target-lexicon@0.12.15
	unicode-bidi@0.3.15
	unicode-ident@1.0.12
	unindent@0.2.3
"
inherit cargo distutils-r1
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/MeirKriheli/${PN}.git"
else
	MY_PV="fc0bb57"
	[[ -n ${PV%%*_p*} ]] && MY_PV="v${PV}"
	SRC_URI="
		mirror://githubcl/MeirKriheli/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
		${CARGO_CRATE_URIS}
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64"
	S="${WORKDIR}/${PN}-${MY_PV#v}"
fi
RESTRICT+=" test"

DESCRIPTION="BiDi layout implementation in pure python"
HOMEPAGE="https://python-bidi.readthedocs.org"

LICENSE="LGPL-3"
SLOT="0"
distutils_enable_tests pytest
