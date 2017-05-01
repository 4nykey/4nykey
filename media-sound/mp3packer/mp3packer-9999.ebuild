# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

if [[ -z ${PV%%*9999} ]]; then
	EGIT_REPO_URI="https://github.com/rbrito/pkg-${PN}.git"
	inherit git-r3
else
	inherit vcs-snapshot
	MY_PV="26cef03"
	[[ -n ${PV%%*_p*} ]] && MY_PV="upstream/${PV}"
	SRC_URI="
		mirror://githubcl/rbrito/pkg-${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="An MP3 reorganizer"
HOMEPAGE="http://omion.dyndns.org/${PN}"

LICENSE="GPL-2"
SLOT="0"
IUSE=""

DEPEND="
	dev-lang/ocaml[ocamlopt]
"
RDEPEND=""

src_prepare() {
	local PATCHES=(
		"${S}"/debian/patches
		"${FILESDIR}"/${PN}_stdint.diff
	)
	default
	sed -e 's:-ccopt "-save-temps"::' -i makefile
}

src_compile() {
	emake depend
	emake \
		SSEOPT="-ccopt \"${CFLAGS} ${LDFLAGS}\"" \
		${PN}
}

src_install() {
	dobin ${PN}
}
