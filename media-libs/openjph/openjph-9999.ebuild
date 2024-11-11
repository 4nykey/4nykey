# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake-multilib

MY_PN="OpenJPH"
MY_TST="jp2k_test_codestreams-dabb847"
SRC_URI="
	test? (
		mirror://githubcl/aous72/${MY_TST%-*}/tar.gz/${MY_TST##*-}
		-> ${MY_TST}.tar.gz
	)
"
if [[ -z ${PV%%*9999} ]]; then
	EGIT_REPO_URI="https://github.com/aous72/${MY_PN}.git"
	inherit git-r3
	SLOT="0/${PV}"
else
	MY_PV="f9fdf80"
	[[ -n ${PV%%*_p*} ]] && MY_PV="${PV}"
	SRC_URI+="
		mirror://githubcl/aous72/${MY_PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	KEYWORDS="~amd64"
	SLOT="0/$(ver_cut 2)"
	S="${WORKDIR}/${MY_PN}-${MY_PV}"
fi

DESCRIPTION="Open-source implementation of JPEG2000 Part-15, aka JPH or HTJ2K"
HOMEPAGE="https://github.com/aous72/${MY_PN}"

LICENSE="BSD-2"

MY_SIMD=(
	x86_{avx,avx2,avx512f,sse,sse2,ssse3,sse4_2}
	arm_neon
)
IUSE="${MY_SIMD[@]/#/cpu_flags_} +simd test tiff"
RESTRICT="!test? ( test )"
RESTRICT+=" primaryuri"

DEPEND="
	tiff? ( media-libs/tiff:=[${MULTILIB_USEDEP}] )
"
RDEPEND="
	${DEPEND}
"
BDEPEND="
	test? ( dev-cpp/gtest )
"
PATCHES=( "${FILESDIR}"/tests.diff )

multilib_src_configure() {
	local mycmakeargs=(
		-DOJPH_ENABLE_TIFF_SUPPORT=$(usex tiff)
		-DOJPH_BUILD_TESTS=$(usex test)
		-DOJPH_BUILD_STREAM_EXPAND=yes
		-DOJPH_DISABLE_SIMD=$(usex !simd)
	)
	if use simd; then
		mycmakeargs+=(
			-DOJPH_DISABLE_AVX=$(usex !cpu_flags_x86_avx)
			-DOJPH_DISABLE_AVX2=$(usex !cpu_flags_x86_avx2)
			-DOJPH_DISABLE_AVX512=$(usex !cpu_flags_x86_avx512f)
			-DOJPH_DISABLE_SSE=$(usex !cpu_flags_x86_sse)
			-DOJPH_DISABLE_SSE2=$(usex !cpu_flags_x86_sse2)
			-DOJPH_DISABLE_SSSE3=$(usex !cpu_flags_x86_ssse3)
			-DOJPH_DISABLE_SSE4=$(usex !cpu_flags_x86_sse4_2)
			-DOJPH_DISABLE_NEON=$(usex !cpu_flags_arm_neon)
		)
	fi
	cmake_src_configure
	use test && ln -sf ../../${MY_TST} tests/${MY_TST%-*}
}
