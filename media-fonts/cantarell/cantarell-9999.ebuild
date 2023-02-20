# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{9..11} )
MY_PN="${PN}-fonts"
MY_FONT_TYPES=( otf )
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://gitlab.gnome.org/GNOME/${MY_PN}.git"
	REQUIRED_USE="!binary"
else
	MY_P="${MY_PN}-${PV}"
	SRC_URI="
		mirror://gnome/sources/${MY_PN}/$(ver_cut 1-2)/${MY_P}.tar.xz
	"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/${MY_P}"
fi
inherit python-any-r1 font-r1 meson

DESCRIPTION="Default fontset for GNOME Shell"
HOMEPAGE="https://wiki.gnome.org/Projects/CantarellFonts"

LICENSE="OFL-1.1"
SLOT="0"
IUSE="autohint +binary variable"
BDEPEND="
	!binary? (
		$(python_gen_any_dep '
			dev-python/fontMath[${PYTHON_USEDEP}]
			dev-python/ufo2ft[${PYTHON_USEDEP}]
			dev-python/ufoLib2[${PYTHON_USEDEP}]
			variable? ( dev-python/statmake[${PYTHON_USEDEP}] )
		')
		autohint? ( dev-util/psautohint )
	)
"
DOCS=( NEWS README.md )

pkg_setup() {
	font-r1_pkg_setup
	use binary && python-any-r1_pkg_setup
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
	use binary || emesonargs+=(
		$(meson_use variable buildvf)
		$(meson_use !variable buildstatics)
	)
	meson_src_configure
}
