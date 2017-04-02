# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit qmake-utils
if [[ ${PV} = *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/${PN%-*}/${PN}.git"
else
	inherit vcs-snapshot
	MY_PV="${PV/_/-}"
	MY_PV="${MY_PV/rc/RC}"
	SRC_URI="
		mirror://githubcl/${PN%-*}/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="Web eID native host component"
HOMEPAGE="http://${PN%-*}.github.io"
RESTRICT="primaryuri"

LICENSE="LGPL-2.1"
SLOT="0"
IUSE="debug"

DEPEND="
	dev-qt/qtwidgets:5
	dev-libs/openssl:0
	sys-apps/pcsc-lite
"
RDEPEND="
	${DEPEND}
	dev-libs/libdigidoc
"
DEPEND="
	${DEPEND}
	dev-qt/linguist-tools
"

src_prepare() {
	default
	sed \
		-e "s:/usr/lib/${PN}:${EROOT}usr/libexec/${PN}:" \
		-i linux/{,firefox/}org.hwcrypto.native.json
}

src_configure() {
	cd "${S}"/src
	rm -f GNUmakefile
	eqmake5
}

src_compile() {
	emake -C src
}

src_install() {
	local _j=org.hwcrypto.native.json _e=fmpfihjoladdfajbnkdfocnbcehjpogi.json
	exeinto /usr/libexec
	doexe src/${PN}

	insinto /etc/opt/chrome/native-messaging-hosts
	doins linux/${_j}
	dosym \
		../../opt/chrome/native-messaging-hosts/${_j} \
		/etc/chromium/native-messaging-hosts/${_j}

	insinto /usr/$(get_libdir)/mozilla/native-messaging-hosts
	doins linux/firefox/${_j}

	insinto /usr/share/${PN}
	doins ${_e}
	dosym ../../${PN}/${_e} /usr/share/chromium/extensions/${_e}
	dosym ../../${PN}/${_e} /usr/share/google-chrome/extensions/${_e}

	einstalldocs
}

pkg_postinst() {
	elog "To install browser extension visit https://web-eid.com"
}
