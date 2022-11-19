# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="${PN##*-}"
inherit autotools gnome2-utils
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://gitlab.com/skrewball/${MY_PN}.git"
	SRC_URI=""
else
	KEYWORDS= #"~amd64"
	MY_PV="d714eb1"
	[[ -n ${PV%%*_p*} ]] && MY_PV="v${PV}"
	SRC_URI="
		https://gitlab.com/skrewball/${MY_PN}/-/archive/${MY_PV}/${MY_PN}-${MY_PV}.tar.bz2
		-> ${P}.tar.bz2
	"
	RESTRICT="primaryuri"
	S="${WORKDIR}/${MY_PN}-${MY_PV}"
fi

DESCRIPTION="An extension for displaying weather informations in GNOME Shell"
HOMEPAGE="https://gitlab.com/skrewball/${MY_PN}"

LICENSE="GPL-3+"
SLOT="0"
IUSE="nls"

DEPEND="
	app-eselect/eselect-gnome-shell-extensions
	gui-libs/libadwaita[introspection]
	net-libs/libsoup:3.0[introspection]
"
RDEPEND="
	${DEPEND}
"
BDEPEND="
	nls? ( sys-devel/gettext )
"

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
