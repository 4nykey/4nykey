# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit gnome2-utils
if [[ -z ${PV%%*9999} ]]; then
	inherit mercurial
	EHG_REPO_URI="https://bitbucket.org/mathematicalcoffee/${PN}-gnome-shell-extension"
	SRC_URI=""
else
	inherit vcs-snapshot
	KEYWORDS="~amd64 ~x86"
	SRC_URI="
		https://bitbucket.org/mathematicalcoffee/${PN}-gnome-shell-extension/get/6774bac.tar.gz
		-> ${P}.tar.gz
	"
fi

DESCRIPTION="A GNOME shell extension to reduce the horizontal spacing between status area icons"
HOMEPAGE="https://bitbucket.org/mathematicalcoffee/status-area-horizontal-spacing-gnome-shell-extension"

LICENSE="GPL-3"
SLOT="0"
IUSE=""

DEPEND="
	app-eselect/eselect-gnome-shell-extensions
"
RDEPEND="
	${DEPEND}
"

src_prepare() {
	mv ${PN}@mathematical.coffee.gmail.com/schemas "${S}"
}

src_compile() { :; }

src_install() {
	insinto /usr/share/gnome-shell/extensions
	doins -r ${PN}@mathematical.coffee.gmail.com
	insinto /usr/share/glib-2.0/schemas
	doins schemas/*.xml
	dodoc Readme*
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
