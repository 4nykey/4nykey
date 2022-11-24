# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PN="${PN}-app"
if [[ ${PV} = *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/web-eid/${MY_PN}.git"
else
	MY_PV="80485b8"
	[[ -n ${PV%%*_p*} ]] && MY_PV="v$(ver_rs 3 -)"
	MY_LEI="libelectronic-id-5b66d84"
	MY_LPC="libpcsc-cpp-e7d702b"
	MY_LPM="libpcsc-mock-b0c9bc0"
	SRC_URI="
		mirror://githubcl/web-eid/${MY_PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
		mirror://githubcl/web-eid/${MY_LEI%-*}/tar.gz/${MY_LEI##*-}
		-> ${MY_LEI}.tar.gz
		mirror://githubcl/web-eid/${MY_LPC%-*}/tar.gz/${MY_LPC##*-}
		-> ${MY_LPC}.tar.gz
		test? (
			mirror://githubcl/web-eid/${MY_LPM%-*}/tar.gz/${MY_LPM##*-}
			-> ${MY_LPM}.tar.gz
		)
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/${MY_PN}-${MY_PV#v}"
fi
inherit cmake

DESCRIPTION="Native messaging host for the Web eID browser extension"
HOMEPAGE="https://web-eid.eu"

LICENSE="MIT"
SLOT="0"
IUSE="test"

RDEPEND="
	dev-libs/openssl:=
	sys-apps/pcsc-lite
	dev-qt/qtsvg:5=
"
DEPEND="
	${RDEPEND}
	test? ( dev-cpp/gtest )
"
PATCHES=( "${FILESDIR}"/xpi.diff )

src_prepare() {
	if [[ -n ${PV%%*9999} ]]; then
		mv "${WORKDIR}"/${MY_LEI}/* lib/libelectronic-id/
		mv "${WORKDIR}"/${MY_LPC}/* lib/libelectronic-id/lib/libpcsc-cpp/
		use test && mv "${WORKDIR}"/${MY_LPM}/* lib/libelectronic-id/lib/libpcsc-cpp/tests/lib/libpcsc-mock/
	fi
	use test || sed -e '/enable_testing()/,$d' -i \
		{lib/libelectronic-id,lib/libelectronic-id/lib/libpcsc-cpp,.}/CMakeLists.txt
	cmake_src_prepare
}

src_install() {
	cmake_src_install

	dosym ../../../../usr/share/web-eid/eu.webeid.json \
		/etc/opt/chrome/native-messaging-hosts/eu.webeid.json
	dosym ../../../usr/share/web-eid/eu.webeid.json \
		/etc/chromium/native-messaging-hosts/eu.webeid.json
	dosym \
		../../../usr/share/google-chrome/extensions/ncibgoaomkmdpilpocfeponihegamlic.json \
		/etc/chromium/extensions/ncibgoaomkmdpilpocfeponihegamlic.json

	insinto /etc/firefox/policies
	doins "${FILESDIR}"/policies.json
}
