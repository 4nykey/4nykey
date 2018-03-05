# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/caryll/${PN}.git"
else
	inherit vcs-snapshot
	MY_PV="b23979a"
	SRC_URI="
		mirror://githubcl/caryll/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="Merge and share glyphs"
HOMEPAGE="https://github.com/caryll/${PN}"

LICENSE="Apache-2.0"
SLOT="0"
IUSE=""

RDEPEND="
	net-libs/nodejs[npm]
"
DEPEND="
	${RDEPEND}
"

src_prepare() {
	default
	sed -e 's:\r::g' -i bin/_startup
	npm install
}

src_install() {
	local _d="$(get_libdir)/node_modules/${PN}"
	insinto /usr/${_d}
	doins -r "${S}"/.
	fperms +x /usr/${_d}/bin/_startup
	dosym ../${_d}/bin/_startup /usr/bin/${PN}
	einstalldocs
}
