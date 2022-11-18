# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..11} )
DISTUTILS_USE_PEP517=maturin
CRATES="
	ahash-0.8.0
	arrayvec-0.7.2
	associative-cache-1.0.1
	autocfg-1.1.0
	beef-0.5.2
	bytecount-0.6.3
	castaway-0.2.2
	cc-1.0.73
	cfg-if-1.0.0
	chrono-0.4.22
	compact_str-0.6.1
	encoding_rs-0.8.31
	itoa-1.0.4
	libc-0.2.136
	libm-0.1.4
	num-integer-0.1.45
	num-traits-0.2.15
	once_cell-1.15.0
	packed_simd_2-0.3.8
	pyo3-build-config-0.17.2
	pyo3-ffi-0.17.2
	rustversion-1.0.9
	ryu-1.0.11
	serde-1.0.147
	simdutf8-0.1.4
	smallvec-1.10.0
	target-lexicon-0.12.4
	version_check-0.9.4
"
inherit cargo distutils-r1
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/ijl/${PN}.git"
else
	MY_PV="ebfd5f"
	[[ -n ${PV%%*_p*} ]] && MY_PV="${PV}"
	SRC_URI="
		mirror://githubcl/ijl/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
		$(cargo_crate_uris)
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/${PN}-${MY_PV}"
fi

DESCRIPTION="A Python JSON library supporting dataclasses, datetimes and numpy"
HOMEPAGE="https://github.com/ijl/${PN}"

LICENSE="|| ( Apache-2.0 MIT )"
SLOT="0"
IUSE=""

RDEPEND="
"
DEPEND="${RDEPEND}"
distutils_enable_tests pytest
