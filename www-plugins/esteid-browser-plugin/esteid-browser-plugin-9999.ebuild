# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"
inherit nsplugins
MY_PN="browser-token-signing"
MY_PV="${PV/_/-}"
MY_PV="${MY_PV/rc/RC}"
MY_P="${MY_PN}-${MY_PV}"
if [[ ${PV} = *9999* ]]; then
	inherit git-r3
	EGIT_CHECKOUT_DIR="${WORKDIR}/${MY_P}"
	EGIT_REPO_URI="https://github.com/open-eid/${MY_PN}.git"
else
	SRC_URI="
		mirror://githubcl/open-eid/${MY_PN}/tar.gz/v${MY_PV}
		-> ${MY_P}.tar.gz
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

S="${WORKDIR}/${MY_P}"
CMAKE_IN_SOURCE_BUILD='y'

src_unpack() {
	if [[ ${PV} = *9999* ]]; then
		git-r3_src_unpack
	else
		default
	fi
}

src_compile() {
	emake \
		CC="$(tc-getCC)" \
		CPPFLAGS="${CFLAGS}" \
		plugin
}

src_install() {
	insinto "/usr/$(get_libdir)/${PLUGINS_DIR}"
	doins "${WORKDIR}"/${MY_P}/npesteid-firefox-plugin.so
}

pkg_postinst() {
	elog "Estonian ID Card PKCS11 module loader is available at"
	elog "https://addons.mozilla.org/firefox/addon/est-pkcs11-load"
}
