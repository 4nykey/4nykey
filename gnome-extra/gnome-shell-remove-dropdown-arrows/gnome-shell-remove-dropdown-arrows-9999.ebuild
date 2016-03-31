# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit gnome2-utils
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/mpdeimos/${PN}.git"
	SRC_URI=""
else
	inherit vcs-snapshot
	KEYWORDS="~amd64 ~x86"
	SRC_URI="
		mirror://githubcl/mpdeimos/${PN}/tar.gz/version/${PV} -> ${P}.tar.gz
	"
fi

DESCRIPTION="Remove Dropdown Arrows Gnome Shell extension"
HOMEPAGE="https://github.com/mpdeimos/${PN}"

LICENSE="GPL-3"
SLOT="0"
IUSE=""

RDEPEND="
	app-eselect/eselect-gnome-shell-extensions
"
DEPEND="
	${RDEPEND}
"
AUTOTOOLS_AUTORECONF=1
AUTOTOOLS_IN_SOURCE_BUILD=1

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
