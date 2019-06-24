# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

MY_PN="${PN}-fonts"
inherit eapi7-ver
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/GNOME/${MY_PN}.git"
	REQUIRED_USE="!binary"
else
	inherit vcs-snapshot
	MY_PV="76c5a52"
	MY_P="${MY_PN}-${PV%_p*}"
	[[ -n ${PV%%*_p*} ]] && MY_PV="v${PV}"
	SRC_URI="
		!binary? (
			mirror://githubcl/GNOME/${MY_PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
		)
		binary? (
			mirror://gnome/sources/${MY_PN}/$(ver_cut 1-2)/${MY_P}.tar.xz
		)
	"
	KEYWORDS="~amd64 ~x86"
fi
inherit fontmake meson
REQUIRED_USE+="
	binary? ( !font_types_ttf )
"

DESCRIPTION="Default fontset for GNOME Shell"
HOMEPAGE="https://wiki.gnome.org/Projects/CantarellFonts"

LICENSE="OFL-1.1"
SLOT="0"
DEPEND="
	!binary? (
		autohint? ( dev-util/psautohint )
	)
"
DOCS=( NEWS README.md )

pkg_setup() {
	use binary && S="${WORKDIR}/${MY_P}"
	fontmake_pkg_setup
}

src_prepare() {
	default
	use autohint || sed \
		-e "/find_program/s:'psautohint':'true':" -i meson.build
}

src_configure() {
	local emesonargs=(
		$(meson_use binary useprebuilt)
		-Dfontsdir=${FONTDIR}
		-Dbuildappstream=false
	)
	meson_src_configure
}
