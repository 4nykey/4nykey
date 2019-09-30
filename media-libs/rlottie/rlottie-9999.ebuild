# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit meson
if [[ -z ${PV%%*9999} ]]; then
	EGIT_REPO_URI="https://github.com/Samsung/${PN}.git"
	inherit git-r3
else
	inherit vcs-snapshot
	MY_PV="0bfae1d"
	SRC_URI="
		mirror://githubcl/Samsung/${PN}/tar.gz/${MY_PV}
		-> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="A platform independent standalone library that plays Lottie Animation"
HOMEPAGE="https://github.com/Samsung/${PN}"

LICENSE="LGPL-2.1 FTL MIT BSD"
SLOT="0"
IUSE="threads test"

RDEPEND="
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	test? ( dev-cpp/gtest )
"

src_configure() {
	local emesonargs=(
		$(meson_use threads thread)
		$(meson_use test)
		-Dexample=false
	)
	meson_src_configure
}
