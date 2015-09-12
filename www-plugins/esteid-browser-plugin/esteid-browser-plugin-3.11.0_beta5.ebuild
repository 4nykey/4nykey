# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"
inherit cmake-utils nsplugins
MY_PN="browser-token-signing"
MY_PV="${PV/_/-}"
MY_PV="${MY_PV/rc/RC}"
MY_P="${MY_PN}-${MY_PV}"
MY_LN="firefox-pkcs11-loader"
MY_LV="${MY_PV%-*}"
MY_L="${MY_LN}-${MY_LV}"
if [[ ${PV} = *9999* ]]; then
	inherit git-r3
	EGIT_CHECKOUT_DIR="${WORKDIR}/${MY_P}"
	EGIT_REPO_URI="https://github.com/open-eid/${MY_PN}.git"
else
	SRC_URI="
		https://codeload.github.com/open-eid/${MY_PN}/tar.gz/v${MY_PV}
		-> ${MY_P}.tar.gz
		https://codeload.github.com/open-eid/${MY_LN}/tar.gz/v${MY_LV}
		-> ${MY_L}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi


DESCRIPTION="Estonian ID card browser plugin"
HOMEPAGE="http://id.ee/"

LICENSE="LGPL-2.1"
SLOT="0"
IUSE="debug"

DEPEND="
	x11-libs/gtk+:2
	dev-libs/openssl
"
RDEPEND="
	${DEPEND}
	app-misc/esteidcerts
	dev-libs/opensc
"

S="${WORKDIR}/${MY_L}"
CMAKE_IN_SOURCE_BUILD='y'

src_unpack() {
	if [[ ${PV} = *9999* ]]; then
		git-r3_src_unpack
		EGIT_CHECKOUT_DIR="${S}" \
		EGIT_REPO_URI="https://github.com/open-eid/firefox-pkcs11-loader.git" \
		git-r3_src_unpack
	else
		default
	fi
}

src_compile() {
	emake \
		CC="$(tc-getCC)" \
		CPPFLAGS="${CFLAGS}" \
		-C "${WORKDIR}/${MY_P}" plugin
	cmake-utils_src_compile
}

src_install() {
	insinto "/usr/$(get_libdir)/${PLUGINS_DIR}"
	doins "${WORKDIR}"/${MY_P}/npesteid-firefox-plugin.so
	cmake-utils_src_install
}
