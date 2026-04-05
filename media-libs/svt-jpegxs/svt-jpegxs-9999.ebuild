# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake
MY_PN="SVT-JPEG-XS"
if [[ ${PV} == *9999 ]] ; then
	EGIT_REPO_URI="https://github.com/OpenVisualCloud/${MY_PN}.git"
	inherit git-r3
else
	MY_PV="v${PV}"
	SRC_URI="
		mirror://githubcl/OpenVisualCloud/${MY_PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	S="${WORKDIR}/${MY_PN}-${MY_PV#v}"
	KEYWORDS="~amd64"
fi

DESCRIPTION="SVT JPEG XS codec"
HOMEPAGE="https://github.com/OpenVisualCloud/${MY_PN}"

LICENSE="BSD-2-with-patent"
IUSE="test"
SLOT="0"

BDEPEND="
	dev-lang/yasm
"

src_prepare() {
	sed \
		-e '/_FORTIFY_SOURCE/d' \
		-e '/-Werror/d' \
		-i CMakeLists.txt
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_TESTING=$(usex test)
	)
	cmake_src_configure
}
