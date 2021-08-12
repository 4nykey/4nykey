# Copyright 2015-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/nemtrif/utfcpp"
else
	MY_PV="b85efd6"
	MY_FT="ftest-9c7e60c"
	[[ -n ${PV%%*_p*} ]] && MY_PV="v${PV}"
	SRC_URI="
		mirror://githubcl/nemtrif/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
		test? (
			mirror://githubcl/nemtrif/${MY_FT%-*}/tar.gz/${MY_FT##*-}
			-> ${MY_FT}.tar.gz
		)
	"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/${PN}-${MY_PV#v}"
fi
inherit cmake

DESCRIPTION="UTF-8 C++ library"
HOMEPAGE="https://github.com/nemtrif/utfcpp"

LICENSE="Boost-1.0"
SLOT="0"
IUSE="test"
RESTRICT="
	!test? ( test )
	primaryuri
"

DEPEND=""
RDEPEND="
	${DEPEND}
"

src_prepare() {
	use test && mv ../${MY_FT}/* extern/ftest
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DUTF8_SAMPLES=no
		-DUTF8_TESTS=$(usex test)
	)
	cmake_src_configure
}
