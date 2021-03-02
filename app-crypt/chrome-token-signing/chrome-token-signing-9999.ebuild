# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DOC_CONTENTS="Few additional steps are required
- for firefox install
https://addons.mozilla.org/firefox/addon/token-signing2
https://addons.mozilla.org/firefox/addon/pkcs11-module-loader
- for chromium see
${EPREFIX}/usr/share/doc/${PF}/esteid-update-nssdb"
DISABLE_AUTOFORMATTING=1

inherit eutils readme.gentoo-r1 qmake-utils
if [[ ${PV} = *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/open-eid/${PN}.git"
else
	MY_PV="${PV/_/-}"
	MY_PV="v${MY_PV/rc/RC}"
	if [[ -z ${PV%%*_p*} ]]; then
		inherit vcs-snapshot
		MY_PV="c0a4ae1"
	fi
	SRC_URI="
		mirror://githubcl/open-eid/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi
MY_DOC="esteid-update-nssdb-3b283c2"
SRC_URI+="
	mirror://githubraw/open-eid/linux-installer/${MY_DOC##*-}/${MY_DOC%-*}
	-> ${MY_DOC}
"

DESCRIPTION="Native client and browser extension for eID"
HOMEPAGE="https://id.ee"

LICENSE="LGPL-2.1"
SLOT="0"
IUSE="debug"

DEPEND="
	dev-qt/qtwidgets:5
	dev-libs/openssl:0
	dev-libs/opensc[pcsc-lite]
"
RDEPEND="
	${DEPEND}
	dev-libs/libdigidoc
	www-plugins/firefox-pkcs11-loader
	dev-libs/nss[utils]
"
BDEPEND="
	dev-qt/linguist-tools
"
PATCHES=( "${FILESDIR}"/${PN}_allow_disabling.diff )

src_configure() {
	cd "${S}"/host-linux
	rm -f GNUmakefile
	eqmake5 LIBPATH="${EPREFIX}/usr/$(get_libdir)"
}

src_compile() {
	emake -C host-linux
	sed \
		-e "/LIBS=/s:=.*:=/usr/$(get_libdir):" \
		-e "/^[A-Z]\+=/s:/usr/:${EPREFIX}&:" \
		"${DISTDIR}"/${MY_DOC} > esteid-update-nssdb
}

src_install() {
	emake INSTALL_ROOT="${ED}" -C host-linux install
	dodoc esteid-update-nssdb

	dosym \
		../../opt/chrome/native-messaging-hosts/ee.ria.esteid.json \
		/etc/chromium/native-messaging-hosts/ee.ria.esteid.json
	dosym \
		../../../opt/chrome/policies/managed/ee.ria.chrome-token-signing.policy.json \
		/etc/chromium/policies/managed/ee.ria.chrome-token-signing.policy.json
	local _x="{443830f0-1fff-4f9a-aa1e-444bafbc7319}.xpi"
	dosym \
		../../../../share/mozilla/extensions/{ec8030f7-c20a-464f-9b0e-13a3a9e97384}/${_x} \
		/usr/$(get_libdir)/firefox/distribution/extensions/${_x}

	readme.gentoo_create_doc
	einstalldocs
}

pkg_postinst() {
	readme.gentoo_print_elog
}
