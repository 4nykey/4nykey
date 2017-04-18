# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

MY_PN="browser-token-signing"
if [[ ${PV} = *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/open-eid/${MY_PN}.git"
else
	inherit vcs-snapshot
	MY_PV="${PV/_/-}"
	MY_PV="v${MY_PV/rc/RC}"
	[[ -z ${PV%%*_p*} ]] && MY_PV="6dca891"
	SRC_URI="
		mirror://githubcl/open-eid/${MY_PN}/tar.gz/${MY_PV}
		-> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi
inherit nsplugins

DESCRIPTION="Estonian ID card browser plugin"
HOMEPAGE="https://open-eid.github.io"

LICENSE="LGPL-2.1"
SLOT="0"
IUSE="debug"

DEPEND="
	x11-libs/gtk+:2
	dev-libs/openssl:0
"
RDEPEND="
	${DEPEND}
	dev-libs/libdigidoc
	dev-libs/opensc
"
DOCS=( README.md RELEASE-NOTES.md )

src_compile() {
	emake \
		-f Makefile.Linux \
		CC="$(tc-getCC)" \
		CPPFLAGS="${CFLAGS}" \
		plugin{,lt,lv}
}

src_install() {
	insinto "/usr/$(get_libdir)/${PLUGINS_DIR}"
	doins npesteid-firefox-plugin*.so
	einstalldocs
}

pkg_postinst() {
	elog "Estonian ID Card PKCS11 module loader is available at"
	elog "https://addons.mozilla.org/firefox/addon/est-pkcs11-load"
}
