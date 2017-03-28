# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit qmake-utils
if [[ ${PV} = *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/open-eid/${PN}.git"
else
	inherit vcs-snapshot
	MY_PV="${PV/_/-}"
	MY_PV="${MY_PV/rc/RC}"
	SRC_URI="
		mirror://githubcl/open-eid/${PN}/tar.gz/v${MY_PV} -> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="A Chrome extension to sign documents on the web with an eID smart card"
HOMEPAGE="http://open-eid.github.io"
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
	app-misc/esteidcerts
"

src_configure() {
	cd "${S}"/host-linux
	rm -f GNUmakefile
	eqmake5
}

src_compile() {
	emake -C host-linux
}

src_install() {
	emake INSTALL_ROOT="${ED}" -C host-linux install

	dosym \
		../../opt/chrome/native-messaging-hosts/ee.ria.esteid.json \
		/etc/chromium/native-messaging-hosts/ee.ria.esteid.json
	dosym \
		../../../../opt/google/chrome/extensions/ckjefchnfjhjfedoccjbhjpbncimppeg.json \
		/usr/share/chromium/extensions/ckjefchnfjhjfedoccjbhjpbncimppeg.json

	einstalldocs
}
