# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

if [[ -z ${PV%%*9999} ]]; then
	EGIT_REPO_URI="https://github.com/vovochka404/${PN}.git"
	inherit git-r3
else
	MY_PV="v${PV}"
	if [[ -z ${PV%%*_p*} ]]; then
		MY_PV="15678da"
		inherit vcs-snapshot
	fi
	SRC_URI="
		mirror://githubcl/vovochka404/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/${PN}-${MY_PV}"
fi
inherit cmake-utils

DESCRIPTION="Plugin that provides system tray icon for deadbeef in Plasma5"
HOMEPAGE="https://github.com/vovochka404/${PN}"

LICENSE="GPL-3"
SLOT="0"
IUSE="gtk gtk3"

DEPEND="
	media-sound/deadbeef[gtk?,gtk3?]
	dev-libs/libdbusmenu
"
RDEPEND="${DEPEND}"
BDEPEND="
	dev-util/glib-utils
"

src_configure() {
	local mycmakeargs=(
		-DUSE_GTK=$(usex gtk)
		-DUSE_GTK3=$(usex gtk3)
	)
	cmake-utils_src_configure
}
