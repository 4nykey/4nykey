# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PN="ddb_misc_headerbar_GTK3"
if [[ -z ${PV%%*9999} ]]; then
	EGIT_REPO_URI="https://github.com/saivert/${PN}.git"
	inherit git-r3
else
	inherit vcs-snapshot
	MY_PV="d10f93e"
	[[ -n ${PV%%*_p*} ]] && MY_PV="v${PV}"
	SRC_URI="
		mirror://githubcl/saivert/${MY_PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi
inherit meson

DESCRIPTION="Adds a headerbar to your DeaDBeeF"
HOMEPAGE="https://github.com/saivert/${PN}"

LICENSE="GPL-2"
SLOT="0"
IUSE=""

DEPEND="
	media-sound/deadbeef[gtk3]
"
RDEPEND="${DEPEND}"
BDEPEND=""

src_install() {
	insinto /usr/$(get_libdir)/deadbeef
	doins "${BUILD_DIR}"/${MY_PN}.so
	default
}
