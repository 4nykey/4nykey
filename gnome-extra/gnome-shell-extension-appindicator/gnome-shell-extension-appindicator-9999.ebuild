# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{9..11} )
inherit gnome2 meson python-single-r1
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/ubuntu/${PN}.git"
	SRC_URI=""
else
	MY_PV="87db22d"
	[[ -n ${PV%%*_p*} ]] && MY_PV="v${PV}"
	SRC_URI="
		mirror://githubcl/ubuntu/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/${PN}-${MY_PV#v}"
fi

DESCRIPTION="Adds AppIndicator support to gnome shell"
HOMEPAGE="https://github.com/ubuntu/${PN}"

LICENSE="GPL-2+"
SLOT="0"
IUSE=""

DEPEND="
	app-eselect/eselect-gnome-shell-extensions
"
RDEPEND="
	${DEPEND}
	>gnome-base/gnome-shell-3.33
	x11-libs/gdk-pixbuf[introspection]
	media-libs/clutter[introspection]
"
BDEPEND="
	sys-devel/gettext
	app-misc/jq
"

src_prepare() {
	sed -e 's:glib-compile-schemas:true:' -i schemas/meson.build
	gnome2_src_prepare
}

src_configure() {
	local emesonargs=(
		-Dlocal_install=disabled
	)
	meson_src_configure
}

pkg_postinst() {
	gnome2_schemas_update
	ebegin "Updating list of installed extensions"
	eselect gnome-shell-extensions update
	eend $?
}

pkg_postrm() {
	gnome2_schemas_update
	ebegin "Updating list of installed extensions"
	eselect gnome-shell-extensions update
	eend $?
}
