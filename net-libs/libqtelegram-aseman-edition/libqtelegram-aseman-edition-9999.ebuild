# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

MY_CG="libqtelegram-code-generator-29462b4"
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/Aseman-Land/${PN}.git"
else
	inherit vcs-snapshot
	MY_PV="1865e02"
	[[ -n ${PV%%*_p*} ]] && MY_PV="v${PV}-stable"
	SRC_URI="
		mirror://githubcl/Aseman-Land/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
		mirror://githubcl/Aseman-Land/${MY_CG%-*}/tar.gz/${MY_CG##*-}
		-> ${MY_CG}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi
inherit qmake-utils

DESCRIPTION="A fork of libqtelegram by Aseman Team"
HOMEPAGE="https://github.com/Aseman-Land/${PN}"

LICENSE="GPL-3"
SLOT="0"
IUSE=""

DEPEND="
	dev-libs/openssl:0
	dev-qt/qtmultimedia:5
"
RDEPEND="${DEPEND}"

src_prepare() {
	default
	local _c="${S}/${MY_CG%-*}"
	sed \
		-e '/libqtelegram-generator/!d' \
		-e "s:\$ASEMAN_SRC_PATH:${S}:g" \
		-i "${S}"/init
	[[ -z ${PV%%*9999} ]] && return
	rm -r "${_c}"
	mv -f "${WORKDIR}"/${MY_CG} "${_c}"
}

src_configure() {
	eqmake5 -r "${S}"/${MY_CG%-*}
	emake
	. "${S}"/init || die
	eqmake5 CONFIG+=typeobjects
}

src_install() {
	emake INSTALL_ROOT="${D}" install
}
