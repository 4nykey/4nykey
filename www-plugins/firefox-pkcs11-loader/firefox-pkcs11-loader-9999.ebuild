# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/open-eid/${PN}.git"
else
	MY_PV="610427e"
	[[ -n ${PV%%*_p*} ]] && MY_PV="v${PV}"
	SRC_URI="
		mirror://githubcl/open-eid/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/${PN}-${MY_PV#v}"
fi

DESCRIPTION="A Firefox extension for automatical loading of OpenSC PKCS11 module"
HOMEPAGE="https://open-eid.github.io"

LICENSE="LGPL-2.1"
SLOT="0"
IUSE=""

BDEPEND="
	${RDEPEND}
	app-arch/zip
"

src_install() {
	local _x="{02274e0c-d135-45f0-8a9c-32b35110e10d}.xpi" \
		_p="share/mozilla/extensions/{ec8030f7-c20a-464f-9b0e-13a3a9e97384}"
	insinto "/usr/${_p}"
	doins "${_x}"
	dosym \
		../../../../${_p}/${_x} \
		/usr/$(get_libdir)/firefox/distribution/extensions/${_x}
	einstalldocs
}
