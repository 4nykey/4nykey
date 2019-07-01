# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DOC_CONTENTS="To use this the OpenSC PKCS#11 module has to be loaded
- for firefox
www-plugins/firefox-pkcs11-loader does this automatically
- for chromium see
${EPREFIX}/usr/share/doc/${PF}/esteid-update-nssdb"
DISABLE_AUTOFORMATTING=1

inherit eutils readme.gentoo-r1 qmake-utils
if [[ ${PV} = *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/open-eid/${PN}.git"
else
	inherit vcs-snapshot
	MY_PV="${PV/_/-}"
	MY_PV="v${MY_PV/rc/RC}"
	[[ -z ${PV%%*_p*} ]] && MY_PV="1c9bebc"
	SRC_URI="
		mirror://githubcl/open-eid/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi
SRC_URI+="
	mirror://githubraw/open-eid/linux-installer/21d2227/esteid-update-nssdb
"

DESCRIPTION="Native client and browser extension for eID"
HOMEPAGE="https://open-eid.github.io"

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
DEPEND="
	${DEPEND}
	dev-qt/linguist-tools
"
PATCHES=( "${FILESDIR}"/${PN}_allow_disabling.diff )

src_configure() {
	cd "${S}"/host-linux
	rm -f GNUmakefile
	eqmake5 LIBPATH="${EROOT}/usr/$(get_libdir)"
}

src_compile() {
	emake -C host-linux
	sed \
		-e "/LIBS=/s:=.*:=/usr/$(get_libdir):" \
		-e "/^[A-Z]\+=/s:/usr/:${EPREFIX}&:" \
		${DISTDIR}/esteid-update-nssdb > esteid-update-nssdb
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

	readme.gentoo_create_doc
	einstalldocs
}

pkg_postinst() {
	readme.gentoo_print_elog
}
