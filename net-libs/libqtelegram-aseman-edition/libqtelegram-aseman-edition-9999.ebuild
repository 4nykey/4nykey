# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/Aseman-Land/${PN}.git"
	DEPEND="
		>=dev-util/libqtelegram-code-generator-${PV}
	"
else
	inherit vcs-snapshot
	MY_PV="1865e02"
	[[ -n ${PV%%*_p*} ]] && MY_PV="v${PV}-stable"
	SRC_URI="
		mirror://githubcl/Aseman-Land/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
	DEPEND="
		dev-util/libqtelegram-code-generator
	"
fi
inherit qmake-utils

DESCRIPTION="A fork of libqtelegram by Aseman Team"
HOMEPAGE="https://github.com/Aseman-Land/${PN}"

LICENSE="GPL-3"
SLOT="0"
IUSE=""

RDEPEND="
	dev-libs/openssl:0
	dev-qt/qtmultimedia:5
"
DEPEND+="
	${RDEPEND}
"

src_prepare() {
	default
	sed \
		-e '/libqtelegram-generator/!d' \
		-e 's:^\./::' \
		-e "s:\$ASEMAN_SRC_PATH:${S}:g" \
		-i "${S}"/init
}

src_configure() {
	. "${S}"/init || die
	eqmake5 CONFIG+=typeobjects
}

src_install() {
	emake INSTALL_ROOT="${D}" install
}
