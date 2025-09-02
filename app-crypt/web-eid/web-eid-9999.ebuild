# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="${PN}-app"
if [[ ${PV} = *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/web-eid/${MY_PN}.git"
else
	MY_PV="80485b8"
	[[ -n ${PV%%*_p*} ]] && MY_PV="v$(ver_rs 3 -)"
	MY_LEI="libelectronic-id-0328016"
	SRC_URI="
		mirror://githubcl/web-eid/${MY_PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
		mirror://githubcl/web-eid/${MY_LEI%-*}/tar.gz/${MY_LEI##*-}
		-> ${MY_LEI}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/${MY_PN}-${MY_PV#v}"
fi
inherit virtualx cmake

DESCRIPTION="Native messaging host for the Web eID browser extension"
HOMEPAGE="https://web-eid.eu"

LICENSE="MIT"
SLOT="0"
IUSE="test"

RDEPEND="
	dev-libs/openssl:=
	sys-apps/pcsc-lite
	dev-qt/qtbase:6=[network,test?,widgets]
	dev-qt/qtsvg:6=
"
DEPEND="
	${RDEPEND}
	test? ( dev-cpp/gtest )
	dev-qt/qttools:6[linguist]
"

src_prepare() {
	if [[ -n ${PV%%*9999} ]]; then
		mv "${WORKDIR}"/${MY_LEI}/* lib/libelectronic-id/
	fi
	use test || sed -e '/enable_testing()/,$d' -i \
		{lib/libelectronic-id,lib/libelectronic-id/lib/libpcsc-cpp,.}/CMakeLists.txt
	sed -e 's:Qt6 Qt5:Qt6:' -i CMakeLists.txt
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DCMAKE_INSTALL_SYSCONFDIR="${EPREFIX}/etc"
		-DQT_VERSION_MAJOR=6
	)
	cmake_src_configure
}

src_test() {
	virtx cmake_src_test
}

src_install() {
	cmake_src_install

	dosym \
		../../../usr/share/google-chrome/extensions/ncibgoaomkmdpilpocfeponihegamlic.json \
		/etc/chromium/extensions/ncibgoaomkmdpilpocfeponihegamlic.json
}

pkg_postinst() {
	einfo "Firefox extension is available at"
	einfo "https://addons.mozilla.org/firefox/addon/web-eid-webextension"
}
