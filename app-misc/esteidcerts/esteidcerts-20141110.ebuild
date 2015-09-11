# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
MY_PN="certs"
if [[ ${PV} = *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/open-eid/${MY_PN}.git"
else
	MY_PV="30c5201af83815950226bd6daf0505d0936fe926"
	SRC_URI="
		https://codeload.github.com/open-eid/${MY_PN}/zip/${MY_PV}
		-> ${P}.zip
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/${MY_PN}-${MY_PV}"
fi

DESCRIPTION="Estonian ID card certificates"
HOMEPAGE="http://id.ee"

LICENSE="LGPL-2.1"
SLOT="0"
IUSE=""

DEPEND=""
RDEPEND="
	${DEPEND}
	!app-misc/sk-certificates
"

src_install() {
	insinto /usr/share/esteid/certs
	doins *.crt
}
