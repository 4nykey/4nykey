# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit gnome2-utils
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/mpdeimos/${PN}.git"
	EGIT_BRANCH=master
	SRC_URI=""
else
	inherit vcs-snapshot
	KEYWORDS="~amd64 ~x86"
	SRC_URI="
		mirror://githubcl/mpdeimos/${PN}/tar.gz/version/${PV} -> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
fi

DESCRIPTION="An extension that removes the dropdown arrows from GS menus"
HOMEPAGE="https://github.com/mpdeimos/${PN}"

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

src_compile() { :; }

src_install() {
	insinto /usr/share/gnome-shell/extensions/remove-dropdown-arrows@mpdeimos.com
	doins -r *.js{,on}
	dodoc README.md
}

pkg_postinst() {
	ebegin "Updating list of installed extensions"
	eselect gnome-shell-extensions update
	eend $?
}

pkg_postrm() {
	ebegin "Updating list of installed extensions"
	eselect gnome-shell-extensions update
	eend $?
}
