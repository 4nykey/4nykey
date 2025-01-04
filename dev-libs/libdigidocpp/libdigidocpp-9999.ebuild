# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

if [[ ${PV} = *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/open-eid/${PN}.git"
else
	MY_PV="${PV/_/-}"
	MY_PV="${MY_PV^^}"
	[[ -z ${PV%%*_p*} ]] && MY_PV="8c95639"
	SRC_URI="
		mirror://githubcl/open-eid/${PN}/tar.gz/v${MY_PV} -> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/${PN}-${MY_PV#v}"
fi
inherit cmake

DESCRIPTION="DigiDoc digital signature library"
HOMEPAGE="https://open-eid.github.io"

LICENSE="LGPL-2.1"
SLOT="0"
IUSE="apidocs test"

RDEPEND="
	dev-libs/opensc:=
	dev-libs/libxml2
	dev-libs/xmlsec:=[openssl]
	sys-libs/zlib[minizip]
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	test? ( dev-libs/boost )
	apidocs? ( app-text/doxygen )
"
DOCS=( AUTHORS README.md RELEASE-NOTES.md )

src_prepare() {
	rm -rf src/minizip
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DCMAKE_DISABLE_FIND_PACKAGE_Doxygen=$(usex !apidocs)
		-DCMAKE_DISABLE_FIND_PACKAGE_SWIG=yes
	)
	cmake_src_configure
}
