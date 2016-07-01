# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit gnome2-utils
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/rgcjonas/${PN}.git"
	SRC_URI=""
else
	inherit vcs-snapshot
	KEYWORDS="~amd64 ~x86"
	SRC_URI="
		mirror://githubcl/rgcjonas/${PN}/tar.gz/v${PV} -> ${P}.tar.gz
	"
fi

DESCRIPTION="Adds AppIndicator support to gnome shell"
HOMEPAGE="https://github.com/rgcjonas/gnome-shell-extension-appindicator"

LICENSE="as-is"
SLOT="0"
IUSE=""

DEPEND="
	app-eselect/eselect-gnome-shell-extensions
"
RDEPEND="
	${DEPEND}
"

src_compile() { :; }

src_install() {
	insinto /usr/share/gnome-shell/extensions/appindicatorsupport@rgcjonas.gmail.com
	doins -r interfaces-xml *.js{,on}
	dodoc README.md
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
