# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit gnome2-utils
if [[ -z ${PV%%*9999} ]]; then
	inherit mercurial
	EHG_REPO_URI="https://bitbucket.org/mathematicalcoffee/${PN}-gnome-shell-extension"
	SRC_URI=""
else
	inherit vcs-snapshot
	MY_PV="3d31211"
	[[ -n ${PV%%*_p*} ]] && MY_PV="v${PV}"
	SRC_URI="
		https://bitbucket.org/mathematicalcoffee/${PN}-gnome-shell-extension/get/${MY_PV}.tar.bz2
		-> ${P}.tar.bz2
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="An GS extension to reduce the horizontal spacing between status area icons"
HOMEPAGE="https://bitbucket.org/mathematicalcoffee/status-area-horizontal-spacing-gnome-shell-extension"

LICENSE="GPL-3"
SLOT="0"
IUSE=""

DEPEND="
	app-eselect/eselect-gnome-shell-extensions
"
RDEPEND="
	${DEPEND}
	gnome-base/gnome-shell
"
DOCS=( Readme.md )

src_compile() { :; }

src_install() {
	einstalldocs
	local _u=$(awk -F= '/^EXTENSION.*=/ {printf $2}' Makefile)
	cd ${_u}
	insinto /usr/share/gnome-shell/extensions/${_u}
	doins *.js*
	insinto /usr/share/glib-2.0/schemas
	doins schemas/*.xml
}

pkg_preinst() {
	gnome2_schemas_savelist
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
