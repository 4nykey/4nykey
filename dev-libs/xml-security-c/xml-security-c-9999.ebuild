# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PN="santuario-cpp"
if [[ ${PV} = *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/apache/${PN}.git"
else
	MY_PV="${PV}"
	[[ -z ${PV%%*_p*} ]] && MY_PV="e764bab"
	SRC_URI="
		mirror://githubcl/apache/${MY_PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/${MY_PN}-${MY_PV}"
fi
inherit autotools

DESCRIPTION="Apache C++ XML security libraries"
HOMEPAGE="https://santuario.apache.org/"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug examples nss static-libs xalan"

RDEPEND="
	>=dev-libs/xerces-c-3.2
	dev-libs/openssl:=
	nss? ( dev-libs/nss )
	xalan? ( dev-libs/xalan-c )
"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"
DOCS=( CHANGELOG.txt NOTICE.txt )

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	local myeconfargs=(
		--with-openssl
		$(use_enable static-libs static)
		$(use_enable debug)
		$(use_with xalan)
		$(use_with nss)
	)
	econf "${myeconfargs[@]}"
}

src_install() {
	default
	use examples || return
	docinto examples
	dodoc xsec/samples/*.cpp
}
