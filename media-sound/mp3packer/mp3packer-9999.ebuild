# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs
if [[ -z ${PV%%*9999} ]]; then
	EGIT_REPO_URI="https://github.com/jpenney/${PN}-fork.git"
	EGIT_BRANCH="feature/portability-updates"
	inherit git-r3
else
	inherit vcs-snapshot
	MY_PV="da61574"
	[[ -n ${PV%%*_p*} ]] && MY_PV="upstream/${PV}"
	SRC_URI="
		mirror://githubcl/jpenney/${PN}-fork/tar.gz/${MY_PV} -> ${P}.tar.gz
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
	dev-ml/ocaml-make
"
RDEPEND=""

src_prepare() {
	local PATCHES=(
		"${FILESDIR}"/${PN}_stdint.diff
	)
	default
}

src_compile() {
	emake CC="$(tc-getCC)" CFLAGS="${CFLAGS}"
}

src_install() {
	dobin ${PN}
}
