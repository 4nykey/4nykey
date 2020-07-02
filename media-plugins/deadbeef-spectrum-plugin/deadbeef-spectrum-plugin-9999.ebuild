# Copyright 2019-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PN="ddb_musical_spectrum"
if [[ -z ${PV%%*9999} ]]; then
	EGIT_REPO_URI="https://github.com/cboxdoerfer/${PN}.git"
	inherit git-r3
else
	inherit vcs-snapshot
	MY_PV="a97fd4e"
	[[ -n ${PV%%*_p*} ]] && MY_PV="v${PV}"
	SRC_URI="
		mirror://githubcl/cboxdoerfer/${MY_PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="Musical spectrum for the DeaDBeeF audio player"
HOMEPAGE="https://github.com/cboxdoerfer/${PN}"

LICENSE="GPL-2"
SLOT="0"
IUSE="gtk gtk3"

DEPEND="
	media-sound/deadbeef[gtk?,gtk3?]
"
RDEPEND="${DEPEND}"
BDEPEND=""

src_compile() {
	emake $(usex gtk gtk2 '') $(usev gtk3)
}

src_install() {
	insinto /usr/$(get_libdir)/deadbeef
	use gtk && doins gtk2/ddb_vis_musical_spectrum_GTK2.so
	use gtk3 && doins gtk3/ddb_vis_musical_spectrum_GTK3.so
	einstalldocs
}
