# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/mapbox/${PN}.git"
else
	MY_PV="v${PV}"
	if [[ -z ${PV%%*_p*} ]]; then
		inherit vcs-snapshot
		MY_PV="3d74170"
	fi
	SRC_URI="
		mirror://githubcl/mapbox/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="An header-only alternative to boost::variant for C++11 and C++14"
HOMEPAGE="https://github.com/mapbox/${PN}"

LICENSE="BSD"
SLOT="0"
IUSE="test"

RDEPEND=""
DEPEND="
	${RDEPEND}
"

src_compile() { :; }

src_install() {
	insinto /usr/include/mapbox
	doins include/mapbox/*.hpp
}
